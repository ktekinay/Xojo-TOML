#tag Class
Protected Class ParseTOMLTests
Inherits TOMLTestGroupBase
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
