#tag Module
Protected Module M_TOML
	#tag Method, Flags = &h0
		Function GenerateTOML_MTC(dict As Dictionary) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsDictionaryArray(arr() As Variant) As Boolean
		  for each item as variant in arr
		    if item.Type <> Variant.TypeObject or not ( item isa Dictionary ) then
		      return false
		    end if
		  next
		  
		  return true
		  
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
