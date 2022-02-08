#tag Class
Protected Class ParseTOMLTests
Inherits TOMLTestGroupBase
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
		Sub ArrayTest()
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
		  var expected as string = EndOfLine + " " + EndOfLine + &u0C + "\  "
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
		Sub DoubleTest()
		  var toml as string
		  var d as Dictionary
		  
		  var actual() as string = array( _
		  "+1.2", _
		  "-3.4", _
		  "3.4e5", _
		  "5.66E3", _
		  "-0.45E-9" _
		  )
		  
		  for each item as string in actual
		    toml = "key1 = " + item
		    d = ParseTOML_MTC( toml )
		    Assert.AreEqual item.ToDouble, d.Value( "key1" ).DoubleValue, item
		  next
		  
		  
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
