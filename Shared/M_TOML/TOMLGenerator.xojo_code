#tag Class
Private Class TOMLGenerator
	#tag Method, Flags = &h21
		Private Function EncodeKey(key As String) As String
		  static rxValidChars as RegEx
		  
		  if rxValidChars is nil then
		    rxValidChars = new RegEx
		    rxValidChars.SearchPattern = "^[a-z0-9\-_]+$"
		  end if
		  
		  if rxValidChars.Search( key ) isa RegExMatch then
		    return key
		  end if
		  
		  var encoded as string = ToBasicString( key )
		  return encoded
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeValue(value As Variant) As String
		  var result as string
		  
		  select case value.Type
		  case Variant.TypeString
		    result = ToBasicString( value.StringValue )
		    
		  case Variant.TypeText
		    var t as Text = value.TextValue
		    var s as string = t
		    result = ToBasicString( s )
		    
		  case Variant.TypeInteger, Variant.TypeInt32, Variant.TypeInt64
		    result = value.IntegerValue.ToString
		    
		  case Variant.TypeDouble, Variant.TypeSingle
		    #pragma warning "Finish encoding doubles"
		    
		  case Variant.TypeBoolean
		    const kTrue as string = "true"
		    const kFalse as string = "false"
		    
		    result = if( value.BooleanValue, kTrue, kFalse )
		    
		  case Variant.TypeObject
		    
		  case else
		    if value.IsArray then
		      #pragma warning "Finish encoding arrays"
		      
		    else
		      var err as new InvalidArgumentException
		      raise err
		      
		    end if
		    
		  end select 
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Generate(d As Dictionary) As String
		  ProcessDictionary( d, 0 )
		  var result as string = String.FromArray( OutputArr, "" )
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function IndentForLevel(level As Integer) As String
		  for i as integer = indents.Count to level
		    indents.Add indents( i - 1 ) + kIndent
		  next
		  
		  return indents( level )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessDictionary(d As Dictionary, level As Integer)
		  //
		  // The caller would have added the reference key for this Dictionary, if any
		  //
		  
		  const kEquals as string = " = "
		  
		  var indent as string = if( level = 0, "", IndentForLevel( level ) )
		  
		  var dictionaryKeys as new Dictionary
		  var arrayKeys as new Dictionary
		  
		  var keys() as variant = d.Keys
		  var values() as variant = d.Values
		  
		  for i as integer = 0 to keys.LastIndex
		    var key as string = keys( i )
		    var value as variant = values( i )
		    
		    if value.IsArray and IsDictionaryArray( value ) then
		      arrayKeys.Value( key ) = value
		    elseif value isa Dictionary and not ( value isa M_TOML.InlineDictionary ) then
		      dictionaryKeys.Value( key ) = value
		      
		    else
		      key = EncodeKey( key )
		      var valueString as string = EncodeValue( value )
		      
		      OutPutArr.Add indent
		      OutputArr.Add key
		      OutputArr.Add kEquals
		      OutputArr.Add valueString
		      OutputArr.Add EndOfLine
		      
		    end if
		    
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToBasicString(mbIn As MemoryBlock) As String
		  var pIn as ptr = mbIn
		  var lastByteIndex as integer = mbIn.Size - 1
		  
		  var outSize as integer = mbIn.Size * 6 * 2
		  
		  if StringEncoderMB is nil then
		    StringEncoderMB = new MemoryBlock( max( outSize, 1024 ) )
		  elseif StringEncoderMB.Size < outSize then
		    StringEncoderMB.Size = outSize
		  end if
		  
		  var pOut as ptr = StringEncoderMB
		  pOut.Byte( 0 ) = kByteQuoteDouble
		  
		  var outByteIndex as integer = 0
		  
		  for byteIndex as integer = 0 to lastByteIndex
		    var thisByte as integer = pIn.Byte( byteIndex )
		    
		    select case thisByte
		    case kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      
		    case kByteBackspace
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowB
		      
		    case kByteFormFeed
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowF
		      
		    case kByteLineFeed
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowN
		      
		    case kByteReturn
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowR
		      
		    case kByteTab
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowT
		      
		    case kByteQuoteDouble
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteQuoteDouble
		      
		    case is < 8, 11, 14 to 31
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowU
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteZero
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteZero
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteZero
		      outByteIndex = outByteIndex + 1
		      var hexValue as string = thisByte.ToHex
		      pOut.Byte( outByteIndex ) = hexValue.Asc
		      
		    case 127
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowU
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteZero
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteZero
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteSeven
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteCapF
		      
		    case else
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = thisByte
		      
		    end select
		  next byteIndex
		  
		  outByteIndex = outByteIndex + 1
		  pOut.Byte( outByteIndex ) = kByteQuoteDouble
		  
		  var result as string = StringEncoderMB.StringValue( 0, outByteIndex + 1, Encodings.UTF8 )
		  return result
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared Indents(0) As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private KeyStack() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private OutputArr() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StringEncoderMB As MemoryBlock
	#tag EndProperty


	#tag Constant, Name = kIndent, Type = String, Dynamic = False, Default = \"  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kQuote, Type = String, Dynamic = False, Default = \"\"", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
