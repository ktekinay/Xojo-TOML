#tag Class
Private Class TOMLGenerator
	#tag Method, Flags = &h21
		Private Sub AddKeyAndValue(key As String, value As Variant, toArr() As String = Nil)
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if toArr = nil then
		    toArr = OutputArr
		  end if
		  
		  key = ToBasicString( key, true )
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
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		Private Function EncodeDate(dt As Date) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var dateString as string = dt.SQLDateTime.Replace( kSpace, "T" )
		  var gmt as double = dt.GMTOffset
		  
		  if gmt = 0.0 then
		    dateString = dateString + "Z"
		    
		  else
		    
		    if gmt > 0.0 then
		      dateString = dateString + "+"
		    else
		      dateString = dateString + "-"
		    end if
		    
		    gmt = abs( gmt )
		    
		    var hours as integer = gmt
		    var fraction as double = gmt - hours
		    var minutes as integer = fraction * 60.0
		    if minutes = 60 then
		      hours = hours + 1
		      minutes = 0
		    end if
		    
		    dateString = dateString + hours.ToString( "00" ) + ":" + minutes.ToString( "00" )
		    
		  end if
		  
		  return dateString
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeDateTime(dt As DateTime) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  //
		  // Special case
		  //
		  if dt isa M_TOML.LocalDateTime and dt.Hour = 0 and dt.Minute = 0 and dt.Second = 0 and dt.Nanosecond = 0 then
		    return dt.SQLDate
		  end if
		  
		  var dateString as string = dt.SQLDateTime.Replace( kSpace, "T" )
		  
		  if dt.Nanosecond <> 0 then
		    static loc as new Locale( "en-US" )
		    
		    var ns as integer = dt.Nanosecond
		    var µs as integer = round( ( ns / 1000.0 ) + 0.5 )
		    var dµs as double = µs / kMillion
		    dateString = dateString + dµs.ToString( loc, ".0#####" )
		  end if
		  
		  if not ( dt isa M_TOML.LocalDateTime ) then
		    var tz as Timezone = dt.Timezone
		    
		    if tz.SecondsFromGMT = 0 then
		      dateString = dateString + "Z"
		      
		    else
		      var secsFromGMT as integer = tz.SecondsFromGMT
		      
		      if tz.SecondsFromGMT > 0 then
		        dateString = dateString + "+"
		      else
		        secsFromGMT = -secsFromGMT
		        dateString = dateString + "-"
		      end if
		      
		      var minsFromGMT as integer = secsFromGMT \ 60
		      var hoursFromGMT as integer = minsFromGMT \ 60
		      minsFromGMT = minsFromGMT mod 60
		      
		      dateString = dateString + hoursFromGMT.ToString( "00" ) + ":" + minsFromGMT.ToString( "00" )
		      
		    end if
		  end if
		  
		  return dateString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeDouble(value As Double) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var result as string = value.ToString( USLocale, "#,##0" )
		  static groupingSep as string = USLocale.GroupingSeparator
		  const kUnderscore as string = "_"
		  result = result.ReplaceAllBytes( groupingSep, kUnderscore )
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeLocalTime(lt As M_TOML.LocalTime) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  return lt.ToString
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeValue(value As Variant) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		    
		  case Variant.TypeDate
		    result = EncodeDate( value )
		    
		  case Variant.TypeDateTime
		    result = EncodeDateTime( value )
		    
		  case Variant.TypeObject
		    if value isa Dictionary then
		      result = EncodeInlineTable( value )
		      
		    elseif value isa M_TOML.LocalTime then
		      result = EncodeLocalTime( value )
		      
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
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  CurrentLevel = 0
		  ProcessDictionary( d )
		  var result as string = String.FromArray( OutputArr, "" )
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IndentForLevel() As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  for level as integer = indents.Count to CurrentLevel
		    indents.Add indents( level - 1 ) + kIndent
		  next
		  
		  return indents( CurrentLevel )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsDictionaryArray(value As Variant) As Boolean
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  //
		  // The caller would have added the reference key for this Dictionary, if any
		  //
		  
		  var indent as string = IndentForLevel
		  
		  var dictionaryKeys as Dictionary = ParseJSON( "{}" )
		  var arrayKeys as Dictionary = ParseJSON( "{}" )
		  
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
		    
		    key = ToBasicString( key, true )
		    KeyStack.Add key
		    
		    OutputArr.Add EndOfLine
		    OutputArr.Add indent
		    OutputArr.Add kSquareBracketOpenAndSpace
		    OutputArr.Add String.FromArray( KeyStack, "." )
		    OutputArr.Add kSquareBracketCloseWithSpace
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
		      
		      key = ToBasicString( key, true )
		      KeyStack.Add key
		      
		      OutputArr.Add EndOfLine
		      OutputArr.Add indent
		      OutputArr.Add kSquareBracketOpenDoubleAndSpace
		      OutputArr.Add String.FromArray( KeyStack, "." )
		      OutputArr.Add kSquareBracketCloseDoubleWithSpace
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
		Private Function ToBasicString(mbIn As MemoryBlock, isKey As Boolean = False) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
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
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      
		    case kByteBackspace
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowB
		      
		    case kByteFormFeed
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowF
		      
		    case kByteLineFeed
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowN
		      
		    case kByteReturn
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowR
		      
		    case kByteTab
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowT
		      
		    case kByteQuoteDouble
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteQuoteDouble
		      
		    case is < 8, 11, 14 to 31
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteBackslash
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteLowU
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteZero
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = kByteZero
		      outByteIndex = outByteIndex + 1
		      if thisByte >= 16 then
		        pOut.Byte( outByteIndex ) = kByteOne
		      else
		        pOut.Byte( outByteIndex ) = kByteZero
		      end if
		      outByteIndex = outByteIndex + 1
		      var thisByteMod as integer = thisByte mod 16
		      if thisByteMod < 10 then
		        pOut.Byte( outByteIndex ) = thisByteMod + kByteZero
		      else
		        pOut.Byte( outByteIndex ) = thisByteMod - 10 + kByteCapA
		      end if
		      
		    case 127
		      isKey = false
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
		      
		    case kByteCapA to kByteCapZ, kByteLowA to kByteLowZ, kByteZero to kByteNine, kByteHyphen, kByteUnderscore // Valid key
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = thisByte
		      
		    case else
		      isKey = false
		      outByteIndex = outByteIndex + 1
		      pOut.Byte( outByteIndex ) = thisByte
		      
		    end select
		  next byteIndex
		  
		  var startByte as integer
		  if isKey then
		    startByte = 1
		  else
		    startByte = 0
		    outByteIndex = outByteIndex + 1
		    pOut.Byte( outByteIndex ) = kByteQuoteDouble
		  end if
		  
		  var stringLength as integer = outByteIndex + 1 - startByte
		  if stringLength = 0 then
		    return kQuote + kQuote
		  else
		    var result as string = StringEncoderMB.StringValue( startByte, outByteIndex + 1 - startByte, Encodings.UTF8 )
		    return result
		  end if
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

	#tag Constant, Name = kSquareBracketCloseDoubleWithSpace, Type = String, Dynamic = False, Default = \" ]]", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSquareBracketCloseWithSpace, Type = String, Dynamic = False, Default = \" ]", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSquareBracketOpen, Type = String, Dynamic = False, Default = \"[", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSquareBracketOpenAndSpace, Type = String, Dynamic = False, Default = \"[ ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSquareBracketOpenDoubleAndSpace, Type = String, Dynamic = False, Default = \"[[ ", Scope = Private
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
