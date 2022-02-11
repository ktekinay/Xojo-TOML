#tag Class
Protected Class GenerateTOMLTests
Inherits TOMLTestGroupBase
	#tag Method, Flags = &h0
		Sub ArrayOfDictTest()
		  var d as Dictionary
		  var toml as string
		  
		  var arr() as Dictionary
		  
		  var d1 as new Dictionary
		  d1.Value( "b" ) = 2
		  d1.Value( "c" ) = 3
		  arr.Add d1
		  
		  d1 = new Dictionary
		  arr.Add d1
		  
		  d1 = new Dictionary
		  d1.Value( "d" ) = true
		  arr.Add d1
		  
		  d = new Dictionary
		  d.Value( "a" ) = arr
		  
		  toml = GenerateTOML_MTC( d )
		  Assert.AreEqual kExpectedArrayOfDictTOML, toml
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BasicTest()
		  var d as Dictionary
		  var toml as string
		  
		  d = new Dictionary
		  d.Value( "a" ) = "b"
		  toml = GenerateTOML_MTC( d )
		  Assert.AreEqual "a = ""b""" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = 2
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = 2" + EndOfLine, toml
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoubleTest()
		  var d as Dictionary
		  var toml as string
		  
		  d = new Dictionary
		  d.Value( "a" ) = 1.0
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = 1.0" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = 1234567890.12
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = 1_234_567_890.12" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = -1234567890.12
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = -1_234_567_890.12" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = 9.0e-10
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = 9.0E-10" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = -9.0e-10
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = -9.0E-10" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = 9.123e12
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = 9.123E12" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = -9.123e12
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = -9.123E12" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = val( "inf" )
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = inf" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = val( "-inf" )
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = -inf" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = val( "nan" )
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = nan" + EndOfLine, toml
		  
		  'd = new Dictionary
		  'var db as double = val( "nan" )
		  'db = -db
		  'd.Value( "a" ) = db
		  'toml = GenerateTOML_MTC( d )
		  'Assert.AreSame "a = -nan" + EndOfLine, toml
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmbeddedDictionaryTest()
		  var d as new Dictionary
		  var d1 as new Dictionary
		  var d2 as new Dictionary
		  
		  d1.Value( "c" ) = 1
		  d1.Value( "d" ) = 2
		  
		  d2.Value( "e" ) = false
		  
		  d1.Value( "b" ) = d2
		  
		  d.Value( "a" ) = d1
		  d.Value( "z" ) = true
		  
		  var toml as string = GenerateTOML_MTC( d )
		  Assert.AreSame kExpectedEmbeddedDictTOML, toml
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InlineArrayTest()
		  var d as Dictionary
		  var toml as string
		  
		  if true then
		    var arr() as boolean = array( true, false )
		    d = new Dictionary
		    d.Value( "a" ) = arr
		    toml = GenerateTOML_MTC( d )
		    Assert.AreSame "a = [ true, false, ]" + EndOfLine, toml
		  end if
		  
		  if true then
		    var arr() as integer = array( 1, 2 )
		    d = new Dictionary
		    d.Value( "a" ) = arr
		    toml = GenerateTOML_MTC( d )
		    Assert.AreSame "a = [ 1, 2, ]" + EndOfLine, toml
		  end if
		  
		  if true then
		    var arr() as integer = array( 1111, 22222 )
		    d = new Dictionary
		    d.Value( "a" ) = arr
		    toml = GenerateTOML_MTC( d )
		    Assert.AreSame "a = [ 1_111, 22_222, ]" + EndOfLine, toml
		  end if
		  
		  if true then
		    var arr() as string = array( "abc", "def""ge" )
		    d = new Dictionary
		    d.Value( "a" ) = arr
		    toml = GenerateTOML_MTC( d )
		    Assert.AreSame "a = [ ""abc"", ""def\""ge"", ]" + EndOfLine, toml
		  end if
		  
		  if true then
		    var arr() as double = array( 1.5, 6789.56 )
		    d = new Dictionary
		    d.Value( "a" ) = arr
		    toml = GenerateTOML_MTC( d )
		    Assert.AreSame "a = [ 1.5, 6_789.56, ]" + EndOfLine, toml
		  end if
		  
		  if true then
		    var arr() as variant = array( 1.5, true )
		    d = new Dictionary
		    d.Value( "a" ) = arr
		    toml = GenerateTOML_MTC( d )
		    Assert.AreSame "a = [ 1.5, true, ]" + EndOfLine, toml
		  end if
		  
		  if true then
		    var arr() as variant = array( 1.5, true, "string", 7 )
		    d = new Dictionary
		    d.Value( "a" ) = arr
		    toml = GenerateTOML_MTC( d )
		    var expected as string = String.FromArray( array( "a = [", "  1.5,", "  true,", "  ""string"",", "  7,", "]", "" ), EndOfLine )
		    Assert.AreSame expected, toml
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InlineTableTest()
		  var d as Dictionary
		  var toml as string
		  
		  if true then
		    var inline as new M_TOML.InlineDictionary
		    inline.Value( "z" ) = 2
		    inline.Value( "y" ) = 1
		    
		    d = new Dictionary
		    d.Value( "a" ) = inline
		    
		    toml = GenerateTOML_MTC( d ).Trim
		    if toml = "a = { z = 2, y = 1 }" or toml = "a = { y = 1, z = 2 }" then
		      Assert.Pass
		    else
		      Assert.Fail toml, "Did not properly encode"
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntegerTest()
		  var d as Dictionary
		  var toml as string
		  
		  d = new Dictionary
		  d.Value( "a" ) = 1
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = 1" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = 1234567890
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = 1_234_567_890" + EndOfLine, toml
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub KeyTest()
		  var d as Dictionary
		  var toml as string
		  
		  d = new Dictionary
		  d.Value( "a" + &uA + "b" ) = 1
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame """a\nb"" = 1" + EndOfLine, toml
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringTest()
		  var d as Dictionary
		  var toml as string
		  
		  d = new Dictionary
		  d.Value( "a" ) = "a" + &u9 + "b"
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = ""a\tb""" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = "a" + &u8 + "b"
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = ""a\bb""" + EndOfLine, toml
		  
		  d = new Dictionary
		  d.Value( "a" ) = "a" + &u7F + "b"
		  toml = GenerateTOML_MTC( d )
		  Assert.AreSame "a = ""a\u007Fb""" + EndOfLine, toml
		End Sub
	#tag EndMethod


	#tag Constant, Name = kExpectedArrayOfDictTOML, Type = String, Dynamic = False, Default = \"[[ a ]]\n  b \x3D 2\n  c \x3D 3\n\n[[ a ]]\n\n[[ a ]]\n  d \x3D true\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExpectedEmbeddedDictTOML, Type = String, Dynamic = False, Default = \"z \x3D true\n\n[ a ]\n  c \x3D 1\n  d \x3D 2\n\n  [ a.b ]\n    e \x3D false\n", Scope = Private
	#tag EndConstant


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
