#tag Module
Protected Module M_TOML
	#tag Method, Flags = &h0
		Function GenerateTOML_MTC(dict As Dictionary) As String
		  var generator as new M_TOML.TOMLGenerator
		  var result as string = generator.Generate( dict )
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParseTOML_MTC(toml As String) As Dictionary
		  #if not DebugBuild then
		    #pragma BoundsChecking false
		    #pragma BreakOnExceptions false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var parser as new M_TOML.TOMLParser
		  var dict as Dictionary = parser.Parse( toml )
		  
		  return dict
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RegExMatchToDateTime(match As RegExMatch) As DateTime
		  var year as integer = match.SubExpressionString( 1 ).ToInteger
		  var month as integer = match.SubExpressionString( 2 ).ToInteger
		  var day as integer = match.SubExpressionString( 3 ).ToInteger
		  var hour as integer = match.SubExpressionString( 4 ).ToInteger
		  var minute as integer = match.SubExpressionString( 5 ).ToInteger
		  var second as integer = match.SubExpressionString( 6 ).ToInteger
		  
		  var ns as integer
		  if match.SubExpressionCount >= 8 and match.SubExpressionString( 7 ) <> "" then
		    var nsd as double = match.SubExpressionString( 7 ).ToDouble
		    ns = nsd * kBillion
		  end if
		  
		  static gmt as new TimeZone( 0 )
		  var tz as TimeZone
		  
		  if match.SubExpressionCount = 9 then
		    var offsetTime as string = match.SubExpressionString( 8 )
		    if offsetTime = "Z" then
		      tz = gmt
		      
		    elseif offsetTime <> "" then
		      var parts() as string = offsetTime.Split( ":" )
		      var offsetSecs as integer = ( parts( 0 ).ToInteger  * 60 * 60 ) + ( parts( 1 ).ToInteger * 60 )
		      tz = new TimeZone( offsetSecs )
		      
		    end if
		  end if
		  
		  var dt as new DateTime( year, month, day, hour, minute, second, ns, tz )
		  return dt
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RegExMatchToLocalTime(match As RegExMatch) As M_TOML.LocalTime
		  var hour as integer = match.SubExpressionString( 1 ).ToInteger
		  var minute as integer = match.SubExpressionString( 2 ).ToInteger
		  var second as integer = match.SubExpressionString( 3 ).ToInteger
		  var ns as integer
		  if match.SubExpressionCount = 5 then
		    var nsd as double = match.SubExpressionString( 4 ).ToDouble
		    ns = nsd * kBillion
		  end if
		  
		  var lt as new M_TOML.LocalTime( hour, minute, second, ns )
		  return lt
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static rxDateTimeString as RegEx
			  
			  if rxDateTimeString is nil then
			    rxDateTimeString = new RegEx
			    rxDateTimeString.SearchPattern = "(?m-iUs)^(\d{4})-(\d{2})-(\d{2})[T\x20](\d{2}):(\d{2}):(\d{2})(\.\d{1,})?(Z|[-+]\d{2}:\d{2})?$"
			  end if
			  
			  return rxDateTimeString
			  
			End Get
		#tag EndGetter
		Private RxDateTimeString As RegEx
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static rxLocalDateString as RegEx
			  
			  if rxLocalDateString is nil then
			    rxLocalDateString = new RegEx
			    rxLocalDateString.SearchPattern = "^\d{4}-\d{2}-\d{2}$"
			  end if
			  
			  return rxLocalDateString
			  
			End Get
		#tag EndGetter
		Private RxLocalDateString As RegEx
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static rxTimeString as RegEx
			  
			  if rxTimeString is nil then
			    rxTimeString = new RegEx
			    rxTimeString.SearchPattern = "^(\d{2}):(\d{2}):(\d{2})(\.\d{1,})?$"
			  end if
			  
			  return rxTimeString
			  
			End Get
		#tag EndGetter
		Private RxTimeString As RegEx
	#tag EndComputedProperty


	#tag Constant, Name = kBillion, Type = Double, Dynamic = False, Default = \"1000000000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteBackslash, Type = Double, Dynamic = False, Default = \"92", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteBackspace, Type = Double, Dynamic = False, Default = \"8", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapA, Type = Double, Dynamic = False, Default = \"65", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapE, Type = Double, Dynamic = False, Default = \"69", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapF, Type = Double, Dynamic = False, Default = \"70", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapT, Type = Double, Dynamic = False, Default = \"84", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapU, Type = Double, Dynamic = False, Default = \"85", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCapZ, Type = Double, Dynamic = False, Default = \"90", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteColon, Type = Double, Dynamic = False, Default = \"58", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteComma, Type = Double, Dynamic = False, Default = \"44", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCurlyBraceClose, Type = Double, Dynamic = False, Default = \"125", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteCurlyBraceOpen, Type = Double, Dynamic = False, Default = \"123", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteDot, Type = Double, Dynamic = False, Default = \"46", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteEOL, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteEquals, Type = Double, Dynamic = False, Default = \"61", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteFormFeed, Type = Double, Dynamic = False, Default = \"12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteHash, Type = Double, Dynamic = False, Default = \"35", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteHyphen, Type = Double, Dynamic = False, Default = \"45", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLineFeed, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowA, Type = Double, Dynamic = False, Default = \"97", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowB, Type = Double, Dynamic = False, Default = \"98", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowE, Type = Double, Dynamic = False, Default = \"101", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowF, Type = Double, Dynamic = False, Default = \"102", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kByteLowI, Type = Double, Dynamic = False, Default = \"105", Scope = Private
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

	#tag Constant, Name = kByteReturn, Type = Double, Dynamic = False, Default = \"13", Scope = Private
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

	#tag Constant, Name = kMillion, Type = Double, Dynamic = False, Default = \"1000000", Scope = Private
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
End Module
#tag EndModule
