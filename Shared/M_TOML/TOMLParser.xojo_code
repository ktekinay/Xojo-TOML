#tag Class
Private Class TOMLParser
	#tag Method, Flags = &h21
		Private Function IndexOfByte(p As Ptr, lastByteIndex As Integer, byteIndex As Integer, targetByte As Integer) As Integer
		  //
		  // Get index of the target byte in the row
		  // Will stop at EOL or a comment
		  //
		  
		  const kDefault as integer = -1
		  
		  while byteIndex <= lastByteIndex
		    var thisByte as integer = p.Byte( byteIndex )
		    
		    select case thisByte
		    case targetByte
		      return byteIndex
		      
		    case kByteEOL, kByteHash // EOL or comment will end the search
		      return kDefault
		      
		    end select
		    
		    byteIndex = byteIndex + 1
		  wend
		  
		  return kDefault
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MaybeParseComment(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As Boolean
		  //
		  // Should skip whitespace before calling this
		  //
		  
		  if p.Byte( byteIndex ) = kByteHash then
		    SkipToNextRow p, lastByteIndex, byteIndex
		    return true
		  end if
		  
		  return false
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MaybeRaiseIllegalCharacterException(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer)
		  SkipWhitespace p, lastByteIndex, byteIndex
		  
		  if byteIndex > lastByteIndex or MaybeParseComment( p, lastByteIndex, byteIndex ) then
		    return
		  end if
		  
		  var thisByte as integer = p.Byte( byteIndex )
		  
		  if thisByte = kByteEOL then
		    SkipToNextRow p, lastByteIndex, byteIndex
		    return
		  end if
		  
		  var col as integer = byteIndex - RowStartByteIndex + 1
		  var msg as string = "Illegal characters on row " + RowNumber.ToString + ", column " + col.ToString
		  RaiseException msg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MaybeRaiseUnexpectedCharException(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer, expectedByte As Integer)
		  MaybeRaiseUnexpectedEOLException p, lastByteIndex, byteIndex
		  
		  if p.Byte( byteIndex ) <> expectedByte then
		    var col as integer = byteIndex - RowStartByteIndex + 1
		    var msg as string = "Error on row " + RowNumber.ToString + ", column " + col.ToString + _
		    ": Expected '" + Encodings.UTF8.Chr( expectedByte ) + _
		    "' but found '" + Encodings.UTF8.Chr( p.Byte( byteIndex ) ) +"'"
		    RaiseException msg
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MaybeRaiseUnexpectedEOLException(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer)
		  SkipWhitespace p, lastByteIndex, byteIndex
		  
		  if byteIndex > lastByteIndex or p.Byte( byteIndex ) = kByteEOL or p.Byte( byteIndex ) = kByteHash then
		    RaiseException "Unexpected end of line in row " + RowNumber.ToString
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Parse(toml As String) As Dictionary
		  var dict as Dictionary = ParseJSON( "{}" )
		  BaseDictionary = dict
		  CurrentDictionary = dict
		  
		  if toml.Encoding is nil then
		    toml = toml.DefineEncoding( Encodings.UTF8 )
		  elseif toml.Encoding <> Encodings.UTF8 then
		    toml = toml.ConvertEncoding( Encodings.UTF8 )
		  end if
		  
		  toml = toml.Trim.ReplaceLineEndings( Encodings.UTF8.Chr( kByteEOL ) )
		  self.TOML = toml
		  
		  //
		  // We will ensure a trailing EOL
		  //
		  var mb as new MemoryBlock( toml.Bytes + 1 )
		  mb.StringValue( 0, toml.Bytes ) = toml
		  mb.Byte( mb.Size - 1 ) = kByteEOL
		  
		  TOMLMemoryBlock = mb
		  
		  #if DebugBuild then
		    self.TOML = mb.StringValue( 0, mb.Size, Encodings.UTF8 )
		  #endif
		  
		  var p as ptr = mb
		  var lastByteIndex as integer = mb.Size - 1
		  var byteIndex as integer = 0
		  
		  while byteIndex <= lastByteIndex
		    ParseNextRow p, lastByteIndex, byteIndex
		  wend
		  
		  return dict
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320616E206172726179206F66206B657973207374617274696E67206174207468697320706F736974696F6E
		Private Function ParseKeys(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As String()
		  //
		  // Should be at the first non-whitespace position
		  //
		  
		  var keys() as string
		  
		  while byteIndex <= lastByteIndex
		    MaybeRaiseUnexpectedEOLException p, lastByteIndex, byteIndex
		    
		    var keyStart as integer = byteIndex
		    var keyLength as integer
		    var expectingKey as boolean = true
		    var expectingEndOfKeys as boolean
		    
		    do
		      var thisByte as integer = p.Byte( byteIndex )
		      
		      select case thisByte
		      case kByteDot
		        if expectingKey or keyLength = 0 then
		          RaiseIllegalKeyException
		        end if
		        
		        keys.Add TOMLMemoryBlock.StringValue( keyStart, keyLength, Encodings.UTF8 )
		        
		        keyLength = 0
		        
		        byteIndex = byteIndex + 1
		        
		        expectingKey = true
		        expectingEndOfKeys = false
		        
		        continue while
		        
		      case kByteTab, kByteSpace
		        if expectingKey or keyLength = 0 then
		          RaiseIllegalKeyException
		        end if
		        
		        keys.Add TOMLMemoryBlock.StringValue( keyStart, keyLength, Encodings.UTF8 )
		        
		        SkipWhitespace p, lastByteIndex, byteIndex
		        keyLength = 0
		        keyStart = byteIndex
		        
		        expectingEndOfKeys = true
		        
		      case kByteSquareBracketClose
		        if expectingKey then
		          RaiseIllegalKeyException
		        end if
		        
		        return keys
		        
		      case kByteHyphen, kByteUnderscore, kByteCapA to kByteCapZ, kByteLowA to kByteLowZ, kByteZero to kByteNine
		        if expectingEndOfKeys then
		          RaiseIllegalKeyException
		        end if
		        
		        keyLength = keyLength + 1
		        byteIndex = byteIndex + 1
		        expectingKey = false
		        
		        continue do
		        
		      case kByteEquals
		        if expectingKey then
		          RaiseIllegalKeyException
		        end if
		        
		        if keyLength <> 0 then
		          keys.Add TOMLMemoryBlock.StringValue( keyStart, keyLength, Encodings.UTF8 )
		        end if
		        
		        return keys
		        
		      end select 
		      
		    loop
		    
		  wend
		  
		  return keys
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseNextRow(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer)
		  RowNumber = RowNumber + 1
		  
		  SkipWhitespace p, lastByteIndex, byteIndex
		  
		  if byteIndex > lastByteIndex then
		    return
		  end if
		  
		  var thisByte as integer = p.Byte( byteIndex )
		  
		  //
		  // Nothing?
		  //
		  if thisByte = kByteEOL then
		    byteIndex = byteIndex + 1
		    RowStartByteIndex = byteIndex
		    return
		  end if
		  
		  //
		  // Comment?
		  //
		  if MaybeParseComment( p, lastByteIndex, byteIndex ) then
		    return
		  end if
		  
		  //
		  // Expecting a key or keys now
		  //
		  var keys() as string
		  
		  //
		  // Dictionary or array header?
		  //
		  var isDictionaryHeader as boolean
		  var isArrayHeader as boolean
		  
		  if thisByte = kByteSquareBracketOpen then
		    byteIndex = byteIndex + 1
		    MaybeRaiseUnexpectedEOLException p, lastByteIndex, byteIndex
		    
		    if p.Byte( byteIndex ) = kByteSquareBracketOpen then // Array header
		      isArrayHeader = true
		      
		      byteIndex = byteIndex + 1
		      SkipWhitespace p, lastByteIndex, byteIndex
		      
		      keys = ParseKeys( p, lastByteIndex, byteIndex )
		      MaybeRaiseUnexpectedCharException p, byteIndex, lastByteIndex, kByteSquareBracketClose
		      byteIndex = byteIndex + 1
		      
		    else // Dictionary header
		      isDictionaryHeader = true
		      
		      keys = ParseKeys( p, lastByteIndex, byteIndex )
		      
		    end if
		    
		    MaybeRaiseUnexpectedCharException p, byteIndex, lastByteIndex, kByteSquareBracketClose
		    byteIndex = byteIndex + 1
		    MaybeRaiseIllegalCharacterException p, lastByteIndex, byteIndex
		    
		  else
		    //
		    // Has to be a straight key
		    //
		    keys = ParseKeys( p, lastByteIndex, byteIndex )
		    MaybeRaiseUnexpectedCharException p, lastByteIndex, byteIndex, kByteEquals
		    byteIndex = byteIndex + 1
		    
		    SkipWhitespace p, lastByteIndex, byteIndex
		    
		    var value as variant = ParseValue( p, lastByteIndex, byteIndex )
		    MaybeRaiseIllegalCharacterException p, lastByteIndex, byteIndex
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseValue(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As Variant
		  var startIndex as integer = byteIndex
		  
		  while byteIndex <= lastByteIndex
		    var thisByte as integer = p.Byte( byteIndex )
		    
		    select case thisByte
		    case kByteEOL, kByteHash
		      return TOMLMemoryBlock.StringValue( startIndex, byteIndex - startIndex + 1, Encodings.UTF8 )
		      
		    end select
		    
		    byteIndex = byteIndex + 1
		  wend
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseException(msg As String)
		  var e as new M_TOML.TOMLException
		  e.Message = msg
		  raise e
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseIllegalKeyException()
		  var msg as string = "An illegal key was found on row " + RowNumber.ToString
		  RaiseException msg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SkipToNextRow(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer)
		  while byteIndex <= lastByteIndex 
		    if p.Byte( byteIndex ) = kByteEOL then
		      byteIndex = byteIndex + 1 // Go to start of next row
		      RowStartByteIndex = byteIndex
		      return
		    end if
		    
		    byteIndex = byteIndex + 1
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SkipWhitespace(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer)
		  while byteIndex <= lastByteIndex 
		    var val as byte = p.Byte( byteIndex )
		    if val = kByteSpace or val = kByteTab then
		      byteIndex = byteIndex + 1
		    else
		      return
		    end if
		  wend
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private BaseDictionary As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CurrentDictionary As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RowNumber As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RowStartByteIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TOML As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TOMLMemoryBlock As MemoryBlock
	#tag EndProperty


	#tag Constant, Name = kByteCapA, Type = Double, Dynamic = False, Default = \"65", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapZ, Type = Double, Dynamic = False, Default = \"90", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteDot, Type = Double, Dynamic = False, Default = \"46", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteEOL, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteEquals, Type = Double, Dynamic = False, Default = \"61", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteHash, Type = Double, Dynamic = False, Default = \"35", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteHyphen, Type = Double, Dynamic = False, Default = \"45", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowA, Type = Double, Dynamic = False, Default = \"97", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowZ, Type = Double, Dynamic = False, Default = \"122", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteNine, Type = Double, Dynamic = False, Default = \"57", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteSpace, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteSquareBracketClose, Type = Double, Dynamic = False, Default = \"93", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteSquareBracketOpen, Type = Double, Dynamic = False, Default = \"91", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteTab, Type = Double, Dynamic = False, Default = \"9", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteUnderscore, Type = Double, Dynamic = False, Default = \"95", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteZero, Type = Double, Dynamic = False, Default = \"48", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kErrorUnexpectedEOL, Type = String, Dynamic = False, Default = \"Unexpected EOL", Scope = Private
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
