#tag Class
Protected Class ParseTOMLTests
Inherits TOMLTestGroupBase
	#tag Method, Flags = &h0
		Sub AddToExistingTableTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = JoinString( "[a.b]", "c=2", "[a]", "b.d=3", "c=5" )
		  d = ParseTOML_MTC( toml )
		  
		  Assert.AreEqual 1, d.KeyCount
		  var d1 as Dictionary = d.Value( "a" )
		  Assert.AreEqual 2, d1.KeyCount
		  Assert.AreEqual 5, d1.Value( "c" ).IntegerValue
		  
		  d1 = d1.Value( "b" )
		  Assert.AreEqual 2, d1.KeyCount
		  Assert.AreEqual 2, d1.Value( "c" ).IntegerValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ArrayHeaderTest()
		  var toml as string
		  var d as Dictionary
		  var arr() as variant
		  var d1 as Dictionary
		  
		  toml = JoinString( "[[header]]", "a = 2", "b=3", "[[header]]", "c = 4" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 1, d.KeyCount, "1 item at top level"
		  arr = d.Value( "header" )
		  var arrCount as integer = arr.Count
		  Assert.AreEqual 2, arrCount, "2 items in array"
		  
		  d1 = arr( 0 )
		  Assert.AreEqual 2, d1.KeyCount, "First sub count"
		  Assert.AreEqual 2, d1.Value( "a" ).IntegerValue
		  
		  d1 = arr( 1 )
		  Assert.AreEqual 1, d1.KeyCount, "Second sub count"
		  Assert.AreEqual 4, d1.Value( "c" ).IntegerValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BadKeyTest()
		  var toml as string
		  
		  #pragma BreakOnExceptions false
		  try
		    toml = "k"
		    call ParseTOML_MTC( toml )
		    Assert.Fail toml
		    
		  catch err as M_TOML.TOMLException
		    Assert.Pass 
		  end try
		  #pragma BreakOnExceptions default
		  
		  #pragma BreakOnExceptions false
		  try
		    toml = "k1 k2"
		    call ParseTOML_MTC( toml )
		    Assert.Fail toml
		    
		  catch err as M_TOML.TOMLException
		    Assert.Pass 
		  end try
		  #pragma BreakOnExceptions default
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BasicStringEscapedCharactersTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = "a=""\r \n\f\\\u0020\U00000020"""
		  d = ParseTOML_MTC( toml )
		  var actual as string = d.Value( "a" )
		  var expected as string = &u0D + " " + &u0A + &u0C + "\  "
		  Assert.AreEqual EncodeHex( expected, true ), EncodeHex( actual, true )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BasicTest()
		  var toml as string = JoinString( "key1 = 1", "key2 = ""word""", "key3='word2'" )
		  var d as Dictionary = ParseTOML_MTC( toml )
		  
		  Assert.IsTrue d isa Dictionary, "Not a Dictionary"
		  
		  if Assert.Failed then
		    return
		  end if
		  
		  Assert.AreEqual 3, d.KeyCount, "Count"
		  Assert.AreEqual 1, d.Lookup( "key1", 0 ).IntegerValue, "key1"
		  Assert.AreEqual "word", d.Lookup( "key2", "" ).StringValue, "key2"
		  Assert.AreEqual "word2", d.Lookup( "key3", "" ).StringValue, "key3"
		  
		  if d.KeyCount <> 0 then
		    Assert.IsFalse d.HasKey( "KEY1" ), "Case-insensitive"
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BooleanTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = JoinString( "a=true", "b=false" )
		  d = ParseTOML_MTC( toml )
		  
		  Assert.AreEqual Variant.TypeBoolean, d.Value( "a" ).Type
		  Assert.AreEqual Variant.TypeBoolean, d.Value( "b" ).Type
		  
		  Assert.IsTrue d.Value( "a" ).BooleanValue
		  Assert.IsFalse d.Value( "b" ).BooleanValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompoundKeyTest()
		  var toml as string
		  var d as Dictionary
		  var d1 as Dictionary
		  
		  toml = "a.b = 22"
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 1, d.KeyCount, "1 item at top level"
		  d1 = d.Value( "a" )
		  Assert.AreEqual 1, d1.KeyCount, "1 item at second level"
		  Assert.AreEqual 22, d1.Value( "b" ).IntegerValue
		  
		  toml = "'a' . ""b"" = 44"
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 1, d.KeyCount, "1 item at top level"
		  d1 = d.Value( "a" )
		  Assert.AreEqual 1, d1.KeyCount, "1 item at second level"
		  Assert.AreEqual 44, d1.Value( "b" ).IntegerValue
		  
		  toml = "'a.b' . ""b.a"" = 88"
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 1, d.KeyCount, "1 item at top level"
		  d1 = d.Value( "a.b" )
		  Assert.AreEqual 1, d1.KeyCount, "1 item at second level"
		  Assert.AreEqual 88, d1.Value( "b.a" ).IntegerValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DateTimeTest()
		  var toml as string
		  var d as Dictionary
		  var dateString as string
		  var dt as DateTime
		  var currentTimeZone as TimeZone = TimeZone.Current
		  
		  'toml = JoinString( "a=1987-04-06T03:46:24", "b=2001-11-15 15:46:01.88698", "c=2005-09-22T12:01:59.776Z", "d=2011-11-02 18:23:03-07:00" )
		  dateString = "1987-01-06T03:46:24"
		  toml = "a=" + DateString
		  d = ParseTOML_MTC( toml )
		  dt = d.Value( "a" )
		  Assert.AreEqual DateString.Replace( "T", " " ), dt.SQLDateTime
		  Assert.AreEqual 0, dt.Nanosecond
		  Assert.AreEqual currentTimeZone.SecondsFromGMT, dt.Timezone.SecondsFromGMT
		  
		  dateString = "2001-11-15 15:46:01.88698"
		  toml = "a=" + DateString
		  d = ParseTOML_MTC( toml )
		  dt = d.Value( "a" )
		  Assert.AreEqual DateString.Replace( "T", " " ).Left( dt.SQLDateTime.Length ), dt.SQLDateTime
		  Assert.AreEqual 886980000, dt.Nanosecond
		  Assert.AreEqual currentTimeZone.SecondsFromGMT, dt.Timezone.SecondsFromGMT
		  
		  dateString = "2005-09-22T12:01:59.776Z"
		  toml = "a=" + DateString
		  d = ParseTOML_MTC( toml )
		  dt = d.Value( "a" )
		  Assert.AreEqual DateString.Replace( "T", " " ).Left( dt.SQLDateTime.Length ), dt.SQLDateTime
		  Assert.IsTrue dt.Nanosecond > 775000000 and dt.Nanosecond < 1000000000
		  Assert.AreEqual 0, dt.Timezone.SecondsFromGMT
		  
		  dateString = "2011-11-02 18:23:03-07:00"
		  toml = "a=" + DateString
		  d = ParseTOML_MTC( toml )
		  dt = d.Value( "a" )
		  Assert.AreEqual DateString.Replace( "T", " " ).Left( dt.SQLDateTime.Length ), dt.SQLDateTime
		  Assert.AreEqual -7 * 60 * 60 , dt.Timezone.SecondsFromGMT
		  
		  dateString = "2011-11-02 18:23:03+07:00"
		  toml = "a=" + DateString
		  d = ParseTOML_MTC( toml )
		  dt = d.Value( "a" )
		  Assert.AreEqual 7 * 60 * 60 , dt.Timezone.SecondsFromGMT
		  
		  dateString = "1979-05-27T07:32:00-08:00#First class dates"
		  toml = "a=" + DateString
		  d = ParseTOML_MTC( toml )
		  dt = d.Value( "a" )
		  Assert.AreEqual DateString.Replace( "T", " " ).Left( dt.SQLDateTime.Length ), dt.SQLDateTime
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoubleTest()
		  var toml as string
		  var d as Dictionary
		  
		  var actual() as string = array( _
		  "inf", _
		  "-inf", _
		  "+inf", _
		  "nan", _
		  "-nan", _
		  "+nan", _
		  "+1.2", _
		  "-3.4", _
		  "3.4e5", _
		  "5.66E3", _
		  "-0.45E-9", _
		  "3_141.5927", _
		  "3141.592_7", _
		  "3e1_4" _
		  )
		  
		  for each item as string in actual
		    toml = "key1 = " + item
		    d = ParseTOML_MTC( toml )
		    var dbl as double = item.ReplaceAll( "_", "" ).ToDouble
		    var areEqual as boolean = item.ReplaceAll( "_", "" ).ToDouble.Equals( d.Value( "key1" ).DoubleValue, 1 )
		    Assert.IsTrue areEqual, item
		    if not areEqual then
		      call ParseTOML_MTC( toml ) // A place to break
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmptyKeyTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = """""="""""
		  d = ParseTOML_MTC( toml )
		  Assert.IsTrue d.HasKey( "" )
		  Assert.AreEqual "", d.Value( "" ).StringValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EncodedNumberTest()
		  var toml as string
		  var d as Dictionary
		  
		  var raw as string
		  var xstring as string
		  
		  raw = "11001100110"
		  xstring = "&b" + raw
		  toml = "key1=0b" + raw
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual xstring.ToInteger, d.Value( "key1" ).IntegerValue, toml
		  
		  raw = "123456701"
		  xstring = "&o" + raw
		  toml = "key1=0o" + raw
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual xstring.ToInteger, d.Value( "key1" ).IntegerValue, toml
		  
		  raw = "abcDEFe012450"
		  xstring = "&h" + raw
		  toml = "key1=0x" + raw
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual xstring.ToInteger, d.Value( "key1" ).IntegerValue, toml
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InlineArrayTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = "a=[1,2,3,]"
		  d = ParseTOML_MTC( toml )
		  var arr() as variant = d.Value( "a" )
		  var arrCount as integer = arr.Count
		  Assert.AreEqual 3, arrCount
		  Assert.AreEqual 1, arr( 0 ).IntegerValue
		  Assert.AreEqual 3, arr( 2 ).IntegerValue
		  
		  toml = "a = [1, 2, 3, ['a', 'b']]"
		  d = ParseTOML_MTC( toml )
		  arr = d.Value( "a" )
		  var arr1() as variant = arr( 3 )
		  Assert.AreEqual "a", arr1( 0 ).StringValue
		  
		  toml = JoinString( "a = [", "1,", "2,", "[5,6]", "]" )
		  d = ParseTOML_MTC( toml )
		  arr = d.Value( "a" )
		  arr1 = arr( 2 )
		  Assert.AreEqual 5, arr1( 0 ).IntegerValue
		  
		  toml = JoinString( "a = [", "1, # comment", "2,", "[5,6]", "]" )
		  d = ParseTOML_MTC( toml )
		  arr = d.Value( "a" )
		  arr1 = arr( 2 )
		  Assert.AreEqual 5, arr1( 0 ).IntegerValue
		  
		  toml = JoinString( "a=1", "b=[4,5,6]", "c=10" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 3, d.KeyCount
		  arr = d.Value( "b" )
		  arrCount = arr.Count
		  Assert.AreEqual 3, arrCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InlineTableTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = "a={b=1, c=true}"
		  d = ParseTOML_MTC( toml )
		  var d1 as Dictionary = d.Value( "a" )
		  Assert.AreEqual 2, d1.KeyCount
		  Assert.AreEqual 1, d1.Value( "b" ).IntegerValue
		  Assert.IsTrue d1.Value( "c" ).BooleanValue
		  
		  toml = JoinString( "a=1", "b={a=2, b=3}", "c=4" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 3, d.KeyCount
		  Assert.AreEqual 1, d.Value( "a" ).IntegerValue
		  Assert.AreEqual 4, d.Value( "c" ).IntegerValue
		  d1 = d.Value( "b" )
		  Assert.AreEqual 2, d1.KeyCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvalidCommentTest()
		  var toml as string
		  
		  toml = JoinString( "# a comment with a bad character " + &u01, "a=1" )
		  #pragma BreakOnExceptions false
		  try
		    call ParseTOML_MTC( toml )
		    Assert.Fail "Should have thrown exception"
		  catch err as M_TOML.TOMLException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LiteralStringTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = "a='abc\'"
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual "abc\", d.Value( "a" ).StringValue
		  
		  toml = JoinString( "a='''", "abc\'''" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual "abc\", d.Value( "a" ).StringValue
		  
		  toml = "a='''a''b'''"
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual "a''b", d.Value( "a" ).StringValue
		  
		  toml = "a='''''b'''''"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LocalDateTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = "a=1967-02-25 # comment"
		  d = ParseTOML_MTC( toml )
		  var dt as DateTime = d.Value( "a" )
		  Assert.IsTrue dt isa M_TOML.LocalDateTime
		  Assert.AreEqual "1967-02-25", dt.SQLDate
		  Assert.AreEqual 0, dt.Hour
		  Assert.AreEqual 0, dt.Minute
		  Assert.AreEqual 0, dt.Second
		  Assert.AreEqual 0, dt.Nanosecond
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LocalDateTimeTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = "a=1967-02-25 01:02:03.5"
		  d = ParseTOML_MTC( toml )
		  var dt as DateTime = d.Value( "a" )
		  Assert.IsTrue dt isa M_TOML.LocalDateTime
		  Assert.AreEqual "1967-02-25", dt.SQLDate
		  Assert.AreEqual 1, dt.Hour
		  Assert.AreEqual 2, dt.Minute
		  Assert.AreEqual 3, dt.Second
		  Assert.AreEqual 500000000, dt.Nanosecond
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MultilineBasicStringTest()
		  var toml as string 
		  var d as Dictionary
		  
		  toml = JoinString( "key1 = """"""", "The quick """" \", "brown fox""""""" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual "The quick """" brown fox", d.Value( "key1" ).StringValue
		  
		  toml = JoinString( "key1 = """"""", "The quick", "brown fox""""""" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual "The quick" + EndOfLine + "brown fox", d.Value( "key1" ).StringValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MultilineLiteralStringTest()
		  var toml as string 
		  var d as Dictionary
		  
		  toml = JoinString( "key1 = '''", "The quick '' \", "brown fox'''" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual "The quick '' \" + EndOfLine + "brown fox", d.Value( "key1" ).StringValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NestedInlineTableTest()
		  var toml as string
		  var d as Dictionary
		  
		  self.StopTestOnFail = true
		  
		  toml = "a = [ { b = {} } ]"
		  d = ParseTOML_MTC( toml )
		  var value as variant = d.Value( "a" )
		  Assert.IsTrue value.IsArray
		  var arr() as variant = value
		  var arrCount as integer = arr.Count
		  Assert.AreEqual 1, arrCount
		  d = arr( 0 )
		  Assert.AreEqual 1, d.KeyCount
		  d = d.Value( "b" )
		  Assert.AreEqual 0, d.KeyCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PreventAddToInlineTableTest()
		  var toml as string
		  
		  toml = JoinString( "a = {b=2}", "a.c=3" )
		  
		  #pragma BreakOnExceptions false
		  try
		    call ParseTOML_MTC( toml )
		    Assert.Fail "Allowed addition to inline table"
		  catch err as M_TOML.TOMLException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PreventEmptyArrayKeyTest()
		  var tests() as string = array( "[[]]", "[[""""]]", "[['']]" )
		  
		  for each toml as string in tests
		    #pragma BreakOnExceptions false
		    try
		      call ParseTOML_MTC( toml )
		      Assert.Fail "Allowed empty table key", toml
		    catch err as M_TOML.TOMLException
		      Assert.Pass
		    end try
		    #pragma BreakOnExceptions default
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PreventEmptyTableKeyTest()
		  var tests() as string = array( "[]", "[""""]", "['']" )
		  
		  for each toml as string in tests
		    #pragma BreakOnExceptions false
		    try
		      call ParseTOML_MTC( toml )
		      Assert.Fail "Allowed empty table key", toml
		    catch err as M_TOML.TOMLException
		      Assert.Pass
		    end try
		    #pragma BreakOnExceptions default
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub QuotedKeyTest()
		  var toml as string
		  var d as Dictionary
		  
		  toml = "'key 1'=1"
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 1, d.Value( "key 1" ).IntegerValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TableHeaderTest()
		  var toml as string
		  var d as Dictionary
		  var d1 as Dictionary
		  
		  toml = JoinString( "[header]", "a = 2", "b=3" )
		  d = ParseTOML_MTC( toml )
		  Assert.AreEqual 1, d.KeyCount, "1 item at top level"
		  d1 = d.Value( "header" )
		  Assert.AreEqual 2, d1.KeyCount, "2 items at second level"
		  Assert.AreEqual 2, d1.Value( "a" ).IntegerValue
		  Assert.AreEqual 3, d1.Value( "b" ).IntegerValue
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
