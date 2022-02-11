#tag Class
Private Class TOMLGenerator
	#tag Method, Flags = &h21
		Private Sub AddKeyAndValue(key As String, value As Variant, toArr() As String = Nil)
		  if toArr = nil then
		    toArr = OutputArr
		  end if
		  
		  key = EncodeKey( key )
		  var valueString as string = EncodeValue( value )
		  
		  toArr.Add key
		  toArr.Add kEqualsWithSpaces
		  toArr.Add valueString
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  if USLocale is nil then
		    USLocale = new Locale( "en-US" )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeArray(value As Variant) As String
		  var result() as string
		  
		  const kAddEOLThreshold as integer = 2
		  
		  var addEOLBetweenElements as boolean
		  
		  result.Add kSquareBracketOpen
		  CurrentLevel = CurrentLevel + 1
		  var indent as string = IndentForLevel
		  
		  select case value.ArrayElementType
		  case Variant.TypeString
		    var arr() as string = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each s as string in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add ToBasicString( s )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeText
		    var arr() as text = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each t as text in arr
		      var s as string = t
		      
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add ToBasicString( s )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeBoolean
		    var arr() as boolean = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each b as boolean in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add if( b, kTrue, kFalse )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeInt32
		    var arr() as Int32 = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each i as integer in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add EncodeInteger( i )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeInt64
		    var arr() as Int64 = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each i as integer in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add EncodeInteger( i )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeInteger
		    var arr() as integer = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each i as integer in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add EncodeInteger( i )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeDouble
		    var arr() as double = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each d as double in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add EncodeDouble( d )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeSingle
		    var arr() as single = value
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each d as double in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add EncodeDouble( d )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  case Variant.TypeObject
		    var a as auto = value
		    var arr() as object = a
		    
		    if arr.Count > kAddEOLThreshold then
		      addEOLBetweenElements = true
		      result.Add EndOfLine
		    else
		      result.Add kSpace
		    end if
		    
		    for each o as variant in arr
		      if addEOLBetweenElements then
		        result.Add indent
		      end if
		      
		      result.Add EncodeValue( o )
		      
		      if addEOLBetweenElements then
		        result.Add kComma
		        result.Add EndOfLine
		      else
		        result.Add kCommaAndSpace
		      end if
		    next
		    
		  end select
		  
		  CurrentLevel = CurrentLevel - 1
		  if addEOLBetweenElements then
		    result.Add IndentForLevel
		  end if
		  result.Add kSquareBracketClose
		  
		  return String.FromArray( result, "" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeDouble(value As Double) As String
		  var result as string
		  
		  var d as double = value
		  var ad as double = abs( d )
		  
		  if d.IsNotANumber then
		    const kNan as string = "nan"
		    const kNegNan as string = "-nan"
		    
		    static nan as double = val( kNan )
		    static negNan as double = -nan
		    
		    result = if( d = negNan, kNegNan, kNan )
		    
		  elseif d.IsInfinite then
		    const kInf as string = "inf"
		    const kNegInf as string = "-inf"
		    
		    result = if( d <> ad, kNegInf, kInf )
		    
		  elseif ad > 1.0e12 or ad < 1.0e-2 then
		    result = d.ToString( USLocale, "0.0#######E0" )
		    
		  else
		    result = d.ToString( USLocale, "#,##0.0##############" )
		    result = result.ReplaceAll( USLocale.GroupingSeparator, "_" )
		  end if
		  
		  result = result.ReplaceAll( ",", "_" )
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeInlineTable(d As Dictionary) As String
		  var result() as string
		  
		  result.Add kCurlyBraceOpen
		  
		  var keys() as variant = d.Keys
		  var values() as variant = d.Values
		  
		  if keys.Count <> 0 then
		    result.Add kSpace
		    for i as integer = 0 to keys.LastIndex
		      var key as string = keys( i )
		      var value as variant = values( i )
		      
		      AddKeyAndValue key, value, result
		      if i <> keys.LastIndex then
		        result.Add kCommaAndSpace
		      end if
		    next
		    result.Add kSpace
		  end if
		  
		  result.Add kCurlyBraceClose
		  return String.FromArray( result, "" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeInteger(value As Integer) As String
		  var result as string = value.ToString( USLocale, "#,##0" )
		  result = result.ReplaceAll( USLocale.GroupingSeparator, "_" )
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeKey(key As String) As String
		  static rxValidChars as RegEx
		  
		  if rxValidChars is nil then
		    rxValidChars = new RegEx
		    rxValidChars.SearchPattern = "\A[a-z0-9\-_]+\z"
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
		  
		  if value.IsArray then
		    return EncodeArray( value )
		  end if
		  
		  select case value.Type
		  case Variant.TypeString
		    result = ToBasicString( value.StringValue )
		    
		  case Variant.TypeText
		    var t as Text = value.TextValue
		    var s as string = t
		    result = ToBasicString( s )
		    
		  case Variant.TypeInteger, Variant.TypeInt32, Variant.TypeInt64
		    result = EncodeInteger( value )
		    
		  case Variant.TypeDouble, Variant.TypeSingle
		    result = EncodeDouble( value )
		    
		  case Variant.TypeBoolean
		    result = if( value.BooleanValue, kTrue, kFalse )
		    
		  case Variant.TypeObject
		    #pragma warning "Finish encoding objects"
		    
		    if value isa Dictionary then
		      result = EncodeInlineTable( value )
		    end if
		    
		  case else
		    var err as new InvalidArgumentException
		    raise err
		    
		  end select 
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Generate(d As Dictionary) As String
		  CurrentLevel = 0
		  ProcessDictionary( d )
		  var result as string = String.FromArray( OutputArr, "" )
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IndentForLevel() As String
		  for level as integer = indents.Count to CurrentLevel
		    indents.Add indents( level - 1 ) + kIndent
		  next
		  
		  return indents( CurrentLevel )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsDictionaryArray(value As Variant) As Boolean
		  if not value.IsArray then
		    return false
		  end if
		  
		  if value.ArrayElementType <> Variant.TypeObject then
		    return false
		  end if
		  
		  var a as auto = value
		  var arr() as object = a
		  
		  if arr.Count = 0 then
		    return false
		  end if
		  
		  for each item as object in arr
		    if not ( item isa Dictionary ) then
		      return false
		    end if
		  next
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessDictionary(d As Dictionary)
		  //
		  // The caller would have added the reference key for this Dictionary, if any
		  //
		  
		  var indent as string = IndentForLevel
		  
		  var dictionaryKeys as new Dictionary
		  var arrayKeys as new Dictionary
		  
		  var keys() as variant = d.Keys
		  var values() as variant = d.Values
		  
		  for i as integer = 0 to keys.LastIndex
		    var key as string = keys( i )
		    var value as variant = values( i )
		    
		    if IsDictionaryArray( value ) then
		      arrayKeys.Value( key ) = value
		      
		    elseif value isa Dictionary and not ( value isa M_TOML.InlineDictionary ) then
		      dictionaryKeys.Value( key ) = value
		      
		    else
		      OutputArr.Add indent
		      AddKeyAndValue key, value
		      OutputArr.Add EndOfLine
		      
		    end if
		    
		  next
		  
		  //
		  // Dictionaries
		  //
		  keys = dictionaryKeys.Keys
		  values = dictionaryKeys.Values
		  
		  for i as integer = 0 to keys.LastIndex
		    var key as string = keys( i )
		    var embeddedDict as Dictionary = values( i )
		    
		    key = EncodeKey( key )
		    KeyStack.Add key
		    
		    OutputArr.Add EndOfLine
		    OutputArr.Add indent
		    OutputArr.Add kSquareBracketOpen
		    OutputArr.Add kSpace
		    OutputArr.Add String.FromArray( KeyStack, "." )
		    OutputArr.Add kSpace
		    OutputArr.Add kSquareBracketClose
		    OutputArr.Add EndOfLine
		    
		    CurrentLevel = CurrentLevel + 1
		    ProcessDictionary embeddedDict
		    CurrentLevel = CurrentLevel -1
		    
		    call KeyStack.Pop
		  next
		  
		  //
		  // Arrays
		  //
		  keys = arrayKeys.Keys
		  values = arrayKeys.Values
		  
		  for i as integer = 0 to keys.LastIndex
		    var key as string = keys( i )
		    var a as auto = values( i )
		    var arr() as object = a
		    
		    for each o as object in arr
		      var arrayDict as Dictionary = Dictionary( o )
		      
		      key = EncodeKey( key )
		      KeyStack.Add key
		      
		      OutputArr.Add EndOfLine
		      OutputArr.Add indent
		      OutputArr.Add kSquareBracketOpen
		      OutputArr.Add kSquareBracketOpen
		      OutputArr.Add kSpace
		      OutputArr.Add String.FromArray( KeyStack, "." )
		      OutputArr.Add kSpace
		      OutputArr.Add kSquareBracketClose
		      OutputArr.Add kSquareBracketClose
		      OutputArr.Add EndOfLine
		      
		      CurrentLevel = CurrentLevel + 1
		      ProcessDictionary arrayDict
		      CurrentLevel = CurrentLevel -1
		      
		      call KeyStack.Pop
		    next
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
		Private CurrentLevel As Integer
	#tag EndProperty

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

	#tag Property, Flags = &h21
		Private Shared USLocale As Locale
	#tag EndProperty


	#tag Constant, Name = kComma, Type = String, Dynamic = False, Default = \"\x2C", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCommaAndSpace, Type = String, Dynamic = False, Default = \"\x2C ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCurlyBraceClose, Type = String, Dynamic = False, Default = \"}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCurlyBraceOpen, Type = String, Dynamic = False, Default = \"{", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kEqualsWithSpaces, Type = String, Dynamic = False, Default = \" \x3D ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFalse, Type = String, Dynamic = False, Default = \"false", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kIndent, Type = String, Dynamic = False, Default = \"  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kQuote, Type = String, Dynamic = False, Default = \"\"", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSpace, Type = String, Dynamic = False, Default = \" ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSquareBracketClose, Type = String, Dynamic = False, Default = \"]", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSquareBracketOpen, Type = String, Dynamic = False, Default = \"[", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTrue, Type = String, Dynamic = False, Default = \"true", Scope = Private
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
