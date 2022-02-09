#tag Class
Protected Class MTOMLTests
Inherits TOMLTestGroupBase
	#tag Method, Flags = &h0
		Sub InlineDictionaryTest()
		  var d as M_TOML.InlineDictionary
		  
		  d = new M_TOML.InlineDictionary
		  d.Value( "a" ) = 1
		  d.Value( "a" ) = 2
		  Assert.AreEqual 2, d.Value( "a" ).IntegerValue
		  
		  d = new M_TOML.InlineDictionary
		  d.Value( "a" ) = 1
		  d.Value( "A" ) = 2
		  d.Value( "b" ) = 3
		  d.Value( "b1" ) = 4
		  Assert.AreEqual 1, d.Value( "a" ).IntegerValue
		  Assert.AreEqual 2, d.Value( "A" ).IntegerValue
		  Assert.AreEqual 3, d.Value( "b" ).IntegerValue
		  Assert.AreEqual 4, d.Value( "b1" ).IntegerValue
		  
		  d = new M_TOML.InlineDictionary( "a" : 1, "A" : 2 )
		  Assert.AreEqual 1, d.Value( "a" ).IntegerValue
		  Assert.AreEqual 2, d.Value( "A" ).IntegerValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LocalTimeTest()
		  var lt as M_TOML.LocalTime
		  
		  lt = new M_TOML.LocalTime( 1, 2, 3 )
		  Assert.AreEqual "01:02:03", lt.ToString
		  
		  var d as new Dictionary
		  d.Value( "a" ) = lt
		  var json as string = GenerateJSON( d )
		  Assert.AreEqual "{""a"":""01:02:03""}", json
		  
		  lt = new M_TOML.LocalTime( 1, 2, 3, 4 )
		  Assert.AreEqual "01:02:03", lt.ToString
		  
		  lt = new M_TOML.LocalTime( 1, 2, 3, 4000000 )
		  Assert.AreEqual "01:02:03.004", lt.ToString
		  
		  lt = new M_TOML.LocalTime( 1, 2, 3, 4000000 )
		  Assert.AreEqual "01:02:03.004", lt.ToString
		  
		  var s as string = "23:24:25.67"
		  lt = M_TOML.LocalTime.FromString( s )
		  Assert.AreEqual s, lt.ToString
		End Sub
	#tag EndMethod


End Class
#tag EndClass
