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
		  
		  var valueString as string = ConvertToString( value )
		  
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
		Private Function ConvertToString(d As Dictionary) As String
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
		Private Function ConvertToString(arr() As Variant) As String
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
		  var indent as string = IndentForCurrentLevel
		  
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
		    
		    result.Add ConvertToString( o )
		    
		    if addEOLBetweenElements then
		      result.Add kComma
		      result.Add EndOfLine
		    else
		      result.Add kCommaAndSpace
		    end if
		  next
		  
		  CurrentLevel = CurrentLevel - 1
		  if addEOLBetweenElements then
		    result.Add IndentForCurrentLevel
		  end if
		  result.Add kSquareBracketClose
		  
		  return String.FromArray( result, "" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ConvertToString(value As Variant) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if value isa Dictionary then
		    var d as Dictionary = value
		    return ConvertToString( d )
		  end if
		  
		  if value.IsArray then
		    var arr() as variant = value
		    return ConvertToString( arr )
		  end if
		  
		  return value.StringValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeArray(value As Variant) As Variant()
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var result() as variant
		  
		  select case value.ArrayElementType
		  case Variant.TypeObject
		    var a as auto = value
		    var arr() as object = a
		    for each item as variant in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeString
		    var arr() as string = value
		    for each item as string in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeText
		    var arr() as text = value
		    for each item as text in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeDouble
		    var arr() as double = value
		    for each item as double in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeSingle
		    var arr() as single = value
		    for each item as single in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeBoolean
		    var arr() as boolean = value
		    for each item as boolean in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeDate
		    var arr() as Date = value
		    for each item as Date in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeDateTime
		    var arr() as DateTime = value
		    for each item as Date in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeInteger
		    var arr() as integer = value
		    for each item as integer in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeInt64
		    var arr() as Int64 = value
		    for each item as integer in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case Variant.TypeInt32
		    var arr() as Int32 = value
		    for each item as integer in arr
		      result.Add EncodeValue( item )
		    next
		    
		  case else
		    raise new InvalidArgumentException( "Invalid type in array" )
		    
		  end select
		  
		  return result()
		  
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
		    var ns as integer = dt.Nanosecond
		    var dµs as double = ns / 1000.0
		    var truncatedµs as integer = dµs
		    dµs = truncatedµs / kMillion
		    dateString = dateString + dµs.ToString( USLocale, ".0#####" )
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
		Private Function EncodeDictionary(sourceDict As Dictionary) As Dictionary
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  //
		  // Copy and consolidate values in this Dictionary
		  //
		  var copy as Dictionary // Don't know yet what it will be
		  
		  var keys() as variant = sourceDict.Keys
		  var values() as variant = sourceDict.Values
		  
		  //
		  // Consolidate and copy each value first
		  //
		  var keysLastIndex as integer = keys.LastIndex
		  for i as integer = 0 to keysLastIndex
		    var key as string = keys( i ).StringValue
		    key = ToBasicString( key, true )
		    keys( i ) = key
		    
		    var value as variant = values( i )
		    
		    value = EncodeValue( value )
		    
		    if value isa Dictionary then
		      var subDict as Dictionary = value
		      if subDict.KeyCount = 0 then
		        value = new M_TOML.InlineDictionary
		      elseif subdict.KeyCount <= 2 and not ( subDict isa M_TOML.InlineDictionary ) then
		        //
		        // We can consolidate this
		        //
		        var subKeys() as variant = subdict.Keys
		        var subValues() as variant = subdict.Values
		        for subIndex as integer = 0 to subKeys.LastIndex
		          var subKey as string = subKeys( subIndex )
		          var subValue as variant = subValues( subIndex )
		          
		          if subIndex = 0 then
		            keys( i ) = key + kDot + subKey
		            value = subValue
		          else
		            keys.Add key + kDot + subKey
		            values.Add subValue
		          end if
		        next
		      end if
		    end if
		    
		    values( i ) = value
		  next
		  
		  //
		  // Determine what kind we need
		  //
		  if sourceDict isa M_TOML.InlineDictionary or values.Count = 0 then
		    copy = new M_TOML.InlineDictionary
		  else
		    copy = ParseJSON( "{}" )
		  end if
		  
		  for i as integer = 0 to keys.LastIndex
		    copy.Value( keys( i ) ) = values( i )
		  next
		  
		  return copy
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
		Private Function EncodeInteger(value As Integer) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var result as string = value.ToString( USLocale, "#,##0" )
		  static groupingSep as string = USLocale.GroupingSeparator
		  result = result.ReplaceAllBytes( groupingSep, kUnderscore )
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodeValue(source As Variant) As Variant
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var value as variant = source
		  
		  if value.IsArray then
		    value = EncodeArray( value )
		    
		  else
		    select case value.Type
		    case Variant.TypeString
		      value = ToBasicString( value.StringValue )
		      
		    case Variant.TypeText
		      var t as text = value.TextValue
		      var s as string = t
		      value = ToBasicString( s )
		      
		    case Variant.TypeInteger, Variant.TypeInt32, Variant.TypeInt64
		      value = EncodeInteger( value.IntegerValue )
		      
		    case Variant.TypeDouble, Variant.TypeSingle
		      value = EncodeDouble( value.DoubleValue )
		      
		    case Variant.TypeBoolean
		      value = if( value.BooleanValue, kTrue, kFalse )
		      
		    case Variant.TypeDate
		      value = EncodeDate( value )
		      
		    case Variant.TypeDateTime
		      value = EncodeDateTime( value )
		      
		    case Variant.TypeObject
		      if value isa Dictionary then
		        value = EncodeDictionary( value )
		      end if
		      
		    case else
		      raise new InvalidArgumentException( "Unrecognized value" )
		    end select
		    
		  end if
		  
		  return value
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Generate(sourceDict As Dictionary) As String
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var tomlDict as Dictionary = EncodeDictionary( sourceDict )
		  
		  OutputArr.RemoveAll
		  KeyStack.RemoveAll
		  CurrentLevel = 0
		  ProcessTOMLDictionary tomlDict
		  
		  var result as string = String.FromArray( OutputArr, "" ).Trim
		  result = result.DefineEncoding( Encodings.UTF8 ) + EndOfLine
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IndentForCurrentLevel() As String
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
		Private Sub ProcessTOMLDictionary(tomlDict As Dictionary)
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var indent as string = IndentForCurrentLevel
		  
		  var keys() as variant = tomlDict.Keys
		  var values() as variant = tomlDict.Values
		  
		  var arrayKeys() as string
		  var arrayValues() as variant
		  
		  var sectionKeys() as string
		  var sectionValues() as variant
		  
		  var thisLevelKeys() as string
		  var thisLevelValues() as variant
		  
		  //
		  // Parse through the keys
		  //
		  for i as integer = 0 to keys.LastIndex
		    var key as string = keys( i )
		    var value as variant = values( i )
		    
		    if not IsInArray and value.IsArray and IsDictionaryArray( value ) then
		      arrayKeys.Add key
		      arrayValues.Add value
		    elseif value isa Dictionary and not ( value isa M_TOML.InlineDictionary ) then
		      sectionKeys.Add key
		      sectionValues.Add value
		    else
		      thisLevelKeys.Add key
		      thisLevelValues.Add value
		    end if
		  next
		  
		  //
		  // Sort each array
		  //
		  
		  SortKeyArray thisLevelKeys, thisLevelValues
		  SortKeyArray sectionKeys, sectionValues
		  SortKeyArray arrayKeys, arrayValues
		  
		  //
		  // Output this level
		  //
		  for i as integer = 0 to thisLevelKeys.LastIndex
		    var key as string = thisLevelKeys( i )
		    var value as variant = thisLevelValues( i )
		    OutputArr.Add indent
		    AddKeyAndValue key, value
		    OutputArr.Add EndOfLine
		  next
		  
		  //
		  // Output sections
		  //
		  
		  for i as integer = 0 to sectionKeys.LastIndex
		    var key as string = sectionKeys( i )
		    var value as variant = sectionValues( i )
		    
		    OutputArr.Add EndOfLine
		    OutputArr.Add indent
		    OutputArr.Add kSquareBracketOpenAndSpace
		    for each k as string in KeyStack
		      OutputArr.Add k
		      OutputArr.Add kDot
		    next
		    OutputArr.Add key
		    OutputArr.Add kSquareBracketCloseWithSpace
		    OutputArr.Add EndOfLine
		    
		    CurrentLevel = CurrentLevel + 1
		    KeyStack.Add key
		    ProcessTOMLDictionary value
		    KeyStack.RemoveAt KeyStack.LastIndex
		    CurrentLevel = CurrentLevel - 1
		  next
		  
		  //
		  // Output arrays
		  //
		  IsInArray = true
		  for i as integer = 0 to arrayKeys.LastIndex
		    var key as string = arrayKeys( i )
		    var arr() as variant = arrayValues( i )
		    
		    for each value as variant in arr
		      OutputArr.Add EndOfLine
		      OutputArr.Add indent
		      OutputArr.Add kSquareBracketOpenDoubleAndSpace
		      for each k as string in KeyStack
		        OutputArr.Add k
		        OutputArr.Add kDot
		      next
		      OutputArr.Add key
		      OutputArr.Add kSquareBracketCloseDoubleWithSpace
		      OutputArr.Add EndOfLine
		      
		      CurrentLevel = CurrentLevel + 1
		      KeyStack.Add key
		      ProcessTOMLDictionary value
		      KeyStack.RemoveAt KeyStack.LastIndex
		      CurrentLevel = CurrentLevel - 1
		    next
		  next
		  IsInArray = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub SortKeyArray(keyArr() As String, valueArr() As Variant)
		  if keyArr.Count < 2 then
		    return
		  end if
		  
		  var sorter() as string
		  sorter.ResizeTo keyArr.LastIndex
		  
		  for i as integer = 0 to keyArr.LastIndex
		    var key as string = keyArr( i )
		    sorter( i ) = EncodeHex( key )
		  next
		  
		  sorter.SortWith keyArr, valueArr
		  
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

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  return mIsInArrayCount > 0
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value then
			    mIsInArrayCount = mIsInArrayCount + 1
			  elseif mIsInArrayCount > 0 then
			    mIsInArrayCount = mIsInArrayCount - 1
			  end if
			  
			End Set
		#tag EndSetter
		Private IsInArray As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private KeyStack() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsInArrayCount As Integer
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

	#tag Constant, Name = kDot, Type = String, Dynamic = False, Default = \".", Scope = Private
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

	#tag Constant, Name = kUnderscore, Type = String, Dynamic = False, Default = \"_", Scope = Private
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
