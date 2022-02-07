#tag Class
Private Class TOMLParser
	#tag Method, Flags = &h21
		Private Function GetChunk(startIndex As Integer, endIndex As Integer) As String
		  if endIndex < startIndex then
		    return ""
		  end if
		  
		  var len as integer = endIndex - startIndex + 1
		  return TOMLMemoryBlock.StringValue( startIndex, len, Encodings.UTF8 )
		  
		End Function
	#tag EndMethod

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
		Private Function InterpretEscaped(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As String
		  //
		  // Will raise an exception if it's not a valid escape character
		  //
		  
		  if byteIndex > lastByteIndex then
		    var msg as string = "Unexpected end of data"
		    RaiseException msg
		  end if
		  
		  var thisByte as integer = p.Byte( byteIndex )
		  
		  select case thisByte
		  case kByteLowB
		    byteIndex = byteIndex + 1
		    return &u08
		    
		  case kByteLowF
		    byteIndex = byteIndex + 1
		    return &u0C
		    
		  case kByteLowN
		    byteIndex = byteIndex + 1
		    return &u0A
		    
		  case kByteLowR
		    byteIndex = byteIndex + 1
		    return &u0D
		    
		  case kByteLowT
		    byteIndex = byteIndex + 1
		    return &u09
		    
		  case kByteBackslash
		    byteIndex = byteIndex + 1
		    return "\"
		    
		  case kByteQuoteDouble
		    byteIndex = byteIndex + 1
		    return """"
		    
		  end select
		  
		  //
		  // If we get here, but be \u or \U
		  //
		  
		  var requiredBytes as integer
		  select case thisByte
		  case kByteLowU
		    requiredBytes = 4
		  case kByteCapU
		    requiredBytes = 8
		  case else
		    RaiseIllegalCharacterException byteIndex
		  end select
		  
		  byteIndex = byteIndex + 1
		  
		  if ( ( lastByteIndex - byteIndex ) + 1 ) < requiredBytes then
		    RaiseUnexpectedEndOfDataException
		  end if
		  
		  //
		  // Let's interpret the bytes
		  //
		  var code as integer
		  for i as integer = 1 to requiredBytes
		    thisByte = p.Byte( byteIndex )
		    select case thisByte
		    case kByteZero to kByteNine
		      code = ( code * 16 ) + ( thisByte - kByteZero )
		      
		    case kByteLowA to kByteLowF
		      code = ( code * 16 ) + 10 + ( thisByte - kByteLowA )
		      
		    case kByteCapA to kByteCapF
		      code = ( code * 16 ) + 10 + ( thisByte - kByteCapA )
		      
		    end select
		    
		    byteIndex = byteIndex + 1
		  next
		  
		  return Encodings.UTF8.Chr( code )
		  
		  '\b         - backspace       (U+0008)
		  '\t         - tab             (U+0009)
		  '\n         - linefeed        (U+000A)
		  '\f         - form feed       (U+000C)
		  '\r         - carriage return (U+000D)
		  '\"         - quote           (U+0022)
		  '\\         - backslash       (U+005C)
		  '\uXXXX     - unicode         (U+XXXX)
		  '\UXXXXXXXX - unicode         (U+XXXXXXXX)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MaybeParseBoolean(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer, ByRef value As Variant) As Boolean
		  #pragma unused lastByteIndex
		  
		  //
		  // Since the MemoryBlock is padded with an EOL, 
		  // these IF statements will short-circuit
		  // before going out of bounds
		  //
		  
		  if _
		    p.Byte( byteIndex ) =     kByteLowT and _
		    p.Byte( byteIndex + 1 ) = kByteLowR and _
		    p.Byte( byteIndex + 2 ) = kByteLowU and _
		    p.Byte( byteIndex + 3 ) = kByteLowE then
		    value = true
		    byteIndex = byteIndex + 4
		    return true
		    
		  elseif _
		    p.Byte( byteIndex ) =     kByteLowF and _
		    p.Byte( byteIndex + 1 ) = kByteLowA and _
		    p.Byte( byteIndex + 2 ) = kByteLowL and _
		    p.Byte( byteIndex + 3 ) = kByteLowS and _
		    p.Byte( byteIndex + 4 ) = kByteLowE then
		    value = false
		    byteIndex = byteIndex + 5
		    return true
		    
		  end if
		  
		  return false
		  
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
		Private Function MaybeParseNumber(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer, ByRef value As Variant) As Boolean
		  var thisByte as integer = p.Byte( byteIndex )
		  
		  if thisByte = kByteZero then
		    var nextByte as integer = p.Byte( byteIndex + 1 )
		    select case nextByte
		    case kByteLowB
		      //
		      // Binary
		      //
		      byteIndex = byteIndex + 2
		      value = ParseBinary( p, lastByteIndex, byteIndex )
		      return true
		      
		    case kByteLowO
		      //
		      // Octal
		      //
		      byteIndex = byteIndex + 2
		      value = ParseOctal( p, lastByteIndex, byteIndex )
		      return true
		      
		    case kByteLowX
		      //
		      // Hex
		      //
		      byteIndex = byteIndex + 2
		      value = ParseHex( p, lastByteIndex, byteIndex )
		      return true
		      
		    case kByteDot, kByteLowE, kByteCapE
		      //
		      // It's a float or scientific notation
		      // let it get processed
		      //
		      
		    case else //  Just a zero
		      value = 0
		      byteIndex = byteIndex + 1
		      return true
		      
		    end select
		  end if
		  
		  var testIndex as integer = byteIndex
		  
		  var sign as integer = 1
		  
		  select case p.Byte( testIndex )
		  case kBytePlus
		    testIndex = testIndex + 1
		  case kByteHyphen
		    testIndex = testIndex + 1
		    sign = -1
		  end select
		  
		  //
		  // Look for integer
		  //
		  do
		    select case p.Byte( testIndex )
		    case kByteUnderscore
		      testIndex = testIndex + 1
		    case kByteZero to kByteNine
		      testIndex = testIndex + 1
		    case kByteDot, kByteLowE, kByteCapE
		      //
		      // Onto the next part
		      //
		      exit do
		      
		    case else
		      var stringLen as integer = testIndex - byteIndex
		      if stringLen = 0 then
		        return false
		      end if
		      
		      var stringValue as string = TOMLMemoryBlock.StringValue( byteIndex, stringLen )
		      value = stringValue.ReplaceAll( "_", "" ).ToInteger
		      byteIndex = testIndex
		      return true
		      
		    end select
		    
		  loop
		  
		  //
		  // A dot?
		  //
		  if p.Byte( testIndex ) = kByteDot then
		    var nextByte as integer = p.Byte( testIndex + 1 )
		     
		    if nextByte < kByteZero or thisByte > kByteNine then
		      RaiseIllegalCharacterException testIndex
		    end if
		    
		    testIndex = testIndex + 1
		    
		    while byteIndex <= lastByteIndex
		      var testByte as integer = p.Byte( testIndex )
		      select case testByte
		      case kByteZero to kByteNine
		        testIndex = testIndex + 1
		      case else
		        exit while
		      end select
		    wend
		  end if
		  
		  //
		  // E?
		  //
		  if p.Byte( testIndex ) = kByteLowE or p.Byte( testIndex ) = kByteCapE then
		    testIndex = testIndex + 1
		    
		    thisByte = p.Byte( testIndex )
		    if thisByte = kBytePlus or thisByte = kByteHyphen then
		      testIndex = testIndex + 1
		      thisByte = p.Byte( testIndex )
		    end if
		    
		    if thisByte < kByteZero or thisByte > kByteNine then
		      RaiseIllegalCharacterException testIndex
		    end if
		    
		    while byteIndex <= lastByteIndex
		      thisByte = p.Byte( testIndex )
		      select case thisByte
		      case kByteZero to kByteNine
		        testIndex = testIndex + 1
		      case else
		        exit while
		      end select
		    wend
		  end if
		  
		  //
		  // Let's send it back
		  //
		  var stringLen as integer = testIndex - byteIndex
		  var stringValue as string = TOMLMemoryBlock.StringValue( byteIndex, stringLen )
		  byteIndex = testIndex
		  
		  value = stringValue.ToDouble
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MaybeParseString(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer, ByRef value As Variant) As Boolean
		  var thisByte as integer = p.Byte( byteIndex )
		  
		  select case thisByte
		  case kByteQuoteSingle
		    value = ParseLiteralString( p, lastByteIndex, byteIndex )
		    return true
		    
		  case kByteQuoteDouble
		    value = ParseBasicString( p, lastByteIndex, byteIndex )
		    return true
		    
		  end select
		  
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
		  
		  RaiseIllegalCharacterException byteIndex
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

	#tag Method, Flags = &h21
		Private Function ParseBasicString(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As String
		  var isMultiline as boolean = p.Byte( byteIndex + 1 ) = kByteQuoteDouble and p.Byte( byteIndex + 2 ) = kByteQuoteDouble
		  
		  if isMultiline then
		    byteIndex = byteIndex + 3
		    if p.Byte( byteIndex ) = kByteEOL then
		      //
		      // We trim this
		      //
		      SkipToNextRow p, lastByteIndex, byteIndex
		    end if
		  else
		    byteIndex = byteIndex + 1
		  end if
		  
		  var chunks() as string
		  var chunkStartIndex as integer = byteIndex
		  
		  while byteIndex <= lastByteIndex
		    var thisByte as integer = p.Byte( byteIndex )
		    select case thisByte
		    case kByteQuoteDouble
		      var chunkEndIndex as integer = byteIndex - 1
		      var isDone as boolean
		      
		      if not isMultiline then
		        isDone = true
		        byteIndex = byteIndex + 1
		      elseif p.Byte( byteIndex + 1 ) = kByteQuoteDouble and p.Byte( byteIndex + 2 ) = kByteQuoteDouble then
		        isDone =  true
		        byteIndex = byteIndex + 3
		      end if
		      
		      if isDone then
		        chunks.Add GetChunk( chunkStartIndex, chunkEndIndex )
		        var result as string = String.FromArray( chunks, "" ).DefineEncoding( Encodings.UTF8 )
		        return result.ReplaceLineEndings( EndOfLine )
		      else
		        byteIndex = byteIndex + 1
		      end if
		      
		    case kByteBackslash
		      chunks.Add GetChunk( chunkStartIndex, byteIndex - 1 )
		      byteIndex = byteIndex + 1
		      
		      //
		      // See if it's just whitespace till the end of the row
		      //
		      var testIndex as integer = byteIndex
		      do
		        var testByte as integer = p.Byte( testIndex )
		        select case testByte
		        case kByteSpace, kByteTab
		          testIndex = testIndex + 1
		          
		        case kByteEOL
		          //
		          // We are trimming this
		          //
		          byteIndex = testIndex
		          SkipToNextRow p, lastByteIndex, byteIndex
		          chunkStartIndex = byteIndex
		          continue while
		          
		        case else
		          //
		          // It's something else
		          //
		          if testIndex <> byteIndex then
		            //
		            // This is an error
		            //
		            RaiseIllegalCharacterException byteIndex
		          end if
		          
		          var value as string = InterpretEscaped( p, lastByteIndex, byteIndex ) // Will raise an exception
		          chunks.Add value
		          
		        end select
		      loop
		      
		    case kByteEOL
		      SkipToNextRow p, lastByteIndex, byteIndex
		      
		    case 0 to 8, 11 to 12, 14 to 31, 127
		      RaiseIllegalCharacterException byteIndex
		      
		    case else
		      byteIndex = byteIndex + 1
		      
		    end select
		  wend
		  
		  //
		  // If we get here, something went wrong
		  //
		  RaiseUnexpectedEndOfDataException
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseBinary(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As Integer
		  var value as integer
		  
		  while byteIndex <= lastByteIndex
		    select case p.Byte( byteIndex )
		    case kByteOne
		      value = value * 2 + 1
		    case kByteZero
		      value = value * 2
		    case else
		      exit while
		    end select
		  wend
		  
		  return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseHex(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As Integer
		  var value as integer
		  
		  while byteIndex <= lastByteIndex
		    var thisByte as integer = p.Byte( byteIndex )
		    select case thisByte
		    case kByteZero to kByteNine
		      value = ( value * 16 ) + ( thisByte - kByteZero )
		    case kByteLowA to kByteLowF
		      value = ( value * 16 ) + 10 + ( thisByte - kByteLowA )
		    case kByteCapA to kByteCapF
		      value = ( value * 16 ) + 10 + ( thisByte - kByteCapF )
		    case else
		      exit while
		    end select
		  wend
		  
		  return value
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
		Private Function ParseLiteralString(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As String
		  var isMultiline as boolean = p.Byte( byteIndex + 1 ) = kByteQuoteSingle and p.Byte( byteIndex + 2 ) = kByteQuoteSingle
		  
		  if isMultiline then
		    byteIndex = byteIndex + 3
		    if p.Byte( byteIndex ) = kByteEOL then
		      //
		      // We trim this
		      //
		      SkipToNextRow p, lastByteIndex, byteIndex
		    end if
		  else
		    byteIndex = byteIndex + 1
		  end if
		  
		  var stringStartIndex as integer = byteIndex
		  
		  while byteIndex <= lastByteIndex
		    var thisByte as integer = p.Byte( byteIndex )
		    select case thisByte
		    case kByteEOL
		      SkipToNextRow p, lastByteIndex, byteIndex
		      
		    case kByteBackslash
		      byteIndex = byteIndex + 1 // Skip the next character no matter what it is
		      
		    case kByteQuoteSingle
		      var isDone as boolean
		      var stringEndIndex as integer = byteIndex - 1
		      
		      if not isMultiline then
		        isDone = true
		        byteIndex = byteIndex + 1
		      elseif p.Byte( byteIndex + 1 ) = kByteQuoteSingle and p.Byte( byteIndex + 2 ) = kByteQuoteSingle then
		        isDone = true
		        byteIndex = byteIndex + 3
		      end if
		      
		      if isDone then
		        var result as string
		        var stringLength as integer = stringEndIndex - stringStartIndex + 1
		        if stringLength <> 0 then
		          result = TOMLMemoryBlock.StringValue( stringStartIndex, stringLength, Encodings.UTF8 )
		        end if
		        
		        return result.ReplaceLineEndings( EndOfLine )
		      end if
		      
		    case 0 to 8, 11 to 12, 14 to 31, 127
		      MaybeRaiseIllegalCharacterException p, lastByteIndex, byteIndex
		      
		    end select
		    
		    byteIndex = byteIndex + 1
		  wend
		  
		  //
		  // If we get here, something went wrong
		  //
		  MaybeRaiseUnexpectedCharException p, lastByteIndex, byteIndex, kByteQuoteSingle
		  
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
		    
		    //
		    // Create the keys as needed
		    //
		    var lastKey as string = keys.Pop
		    
		    var dict as Dictionary = CurrentDictionary
		    for i as integer = 0 to keys.LastIndex
		      var key as string = keys( i )
		      
		      var thisDict as variant = dict.Lookup( key, nil )
		      if thisDict is nil then
		        thisDict = ParseJSON( "{}" )
		        dict.Value( key ) = thisDict
		        dict = thisDict
		        
		      elseif thisDict isa Dictionary then
		        dict = thisDict
		        
		      else
		        RaiseException "They key '" + key + "' is not a table"
		        
		      end if
		    next
		    
		    if dict.HasKey( lastKey ) then
		      RaiseException "Duplicate key '" + lastKey + "' on row " + RowNumber.ToString
		    end if
		    
		    dict.Value( lastKey ) = value
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseOctal(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As Integer
		  var value as integer
		  
		  while byteIndex <= lastByteIndex
		    var thisByte as integer = p.Byte( byteIndex )
		    select case thisByte
		    case kByteZero to kByteSeven
		      value = ( value * 8 ) + ( thisByte - kByteZero )
		    case else
		      exit while
		    end select
		  wend
		  
		  return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseValue(p As Ptr, lastByteIndex As Integer, ByRef byteIndex As Integer) As Variant
		  var value as variant
		  
		  select case true
		  case MaybeParseNumber( p, lastByteIndex, byteIndex, value )
		  case MaybeParseBoolean( p, lastByteIndex, byteIndex, value )
		  case MaybeParseString( p, lastByteIndex, byteIndex, value )
		    
		  case else
		    RaiseException "Illegal value on row " + RowNumber.ToString
		  end select
		  
		  return value
		  
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
		Private Sub RaiseIllegalCharacterException(byteIndex As Integer)
		  var col as integer = byteIndex - RowStartByteIndex + 1
		  var msg as string = "Illegal character on row " + RowNumber.ToString + ", column " + col.ToString
		  RaiseException msg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseIllegalKeyException()
		  var msg as string = "An illegal key was found on row " + RowNumber.ToString
		  RaiseException msg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseUnexpectedEndOfDataException()
		  var msg as string = "Data has ended unexpectedly on row " + RowNumber.ToString
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


	#tag Constant, Name = kByteBackslash, Type = Double, Dynamic = False, Default = \"92", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapA, Type = Double, Dynamic = False, Default = \"65", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapE, Type = Double, Dynamic = False, Default = \"69", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapF, Type = Double, Dynamic = False, Default = \"70", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapU, Type = Double, Dynamic = False, Default = \"85", Scope = Private
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

	#tag Constant, Name = kByteLowB, Type = Double, Dynamic = False, Default = \"98", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowE, Type = Double, Dynamic = False, Default = \"101", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowF, Type = Double, Dynamic = False, Default = \"102", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowL, Type = Double, Dynamic = False, Default = \"108", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowN, Type = Double, Dynamic = False, Default = \"110", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowO, Type = Double, Dynamic = False, Default = \"111", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowR, Type = Double, Dynamic = False, Default = \"114", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowS, Type = Double, Dynamic = False, Default = \"115", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowT, Type = Double, Dynamic = False, Default = \"116", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowU, Type = Double, Dynamic = False, Default = \"117", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowX, Type = Double, Dynamic = False, Default = \"120", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowZ, Type = Double, Dynamic = False, Default = \"122", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteNine, Type = Double, Dynamic = False, Default = \"57", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteOne, Type = Double, Dynamic = False, Default = \"49", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kBytePlus, Type = Double, Dynamic = False, Default = \"43", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteQuoteDouble, Type = Double, Dynamic = False, Default = \"34", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteQuoteSingle, Type = Double, Dynamic = False, Default = \"39", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteSeven, Type = Double, Dynamic = False, Default = \"55", Scope = Private
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
