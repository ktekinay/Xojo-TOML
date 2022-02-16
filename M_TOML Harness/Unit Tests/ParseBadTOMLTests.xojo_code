#tag Class
Protected Class ParseBadTOMLTests
Inherits TOMLTestGroupBase
	#tag Method, Flags = &h0
		Sub ExtendInlineTableTest()
		  var toml as string
		  
		  toml = JoinString( "a = {}", "a.b = 3" )
		  
		  #pragma BreakOnExceptions false
		  try
		    call ParseTOML_MTC( toml )
		    Assert.Fail "Inline tables cannot be extended with key"
		  catch err as M_TOML.TOMLException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  toml = JoinString( "a = {}", "[a.b]" )
		  
		  #pragma BreakOnExceptions false
		  try
		    call ParseTOML_MTC( toml )
		    Assert.Fail "Inline tables cannot be extended with section"
		  catch err as M_TOML.TOMLException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MultilineKeyTest()
		  var toml as string
		  
		  const kQuote as string = """"
		  const kThreeQuotes as string = kQuote + kQuote + kQuote
		  
		  toml = JoinString( kThreeQuotes + "a", "b" + kThreeQuotes + "=1" )
		  
		  #pragma BreakOnExceptions false
		  try
		    call ParseTOML_MTC( toml )
		    Assert.Fail "Long string are not allowed"
		  catch err as M_TOML.TOMLException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MultilineStringTest()
		  var toml as string
		  
		  toml = JoinString( "a =""hi", "ho""" )
		  
		  #pragma BreakOnExceptions false
		  try
		    call ParseTOML_MTC( toml )
		    Assert.Fail "Bad multiline"
		  catch err as M_TOML.TOMLException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RedefineTableTest()
		  var toml as string
		  
		  toml = JoinString( "[a]", "b=2", "[a]", "c=3" )
		  
		  #pragma BreakOnExceptions false
		  try
		    call ParseTOML_MTC( toml )
		    Assert.Fail "Cannot redefine a table"
		  catch err as M_TOML.TOMLException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnderscoreTest()
		  var numbers() as string = array( _
		  "-.12345", _
		  "1__2", _
		  "1._1", _
		  "01", _
		  "_1", _
		  "_01", _
		  "1_", _
		  "-_1", _
		  "+_1", _
		  "1.", _
		  "1.1_", _
		  "1e", _
		  "1_e1", _
		  "1e_1", _
		  "1.1_e1",_
		  "1.1e+_1", _
		  "1.1e-_1", _
		  "1.1e1_", _
		  "0x_1", _
		  "0x1_", _
		  "0x1__1", _
		  "0x1G", _
		  "0b_1", _
		  "0b1_", _
		  "0b1__1", _
		  "0b2", _
		  "0o_1", _
		  "0o1_", _
		  "0o1__1", _
		  "0o9", _
		  "0x", _
		  "0o", _
		  "0b" _
		  )
		  
		  for each num as string in numbers
		    var toml as string = "a=" + num
		    #pragma BreakOnExceptions false
		    try
		      call ParseTOML_MTC( toml )
		      Assert.Fail num
		    catch err as M_TOML.TOMLException
		      Assert.Pass
		    end try
		    #pragma BreakOnExceptions default
		  next
		  
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
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
