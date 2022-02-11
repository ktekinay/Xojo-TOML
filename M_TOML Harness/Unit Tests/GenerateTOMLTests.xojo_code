#tag Class
Protected Class GenerateTOMLTests
Inherits TOMLTestGroupBase
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
