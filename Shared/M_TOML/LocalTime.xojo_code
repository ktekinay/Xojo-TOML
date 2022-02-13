#tag Class
Protected Class LocalTime
	#tag Method, Flags = &h0
		Sub Constructor(hour As Integer, minute As Integer, second As Integer, nanosecond As Integer = 0)
		  if hour < 0 or hour >= 24 then
		    raise new InvalidArgumentException( "Hour is out of range" )
		  end if
		  mHour = hour
		  
		  if minute < 0 or minute >= 60 then
		    raise new InvalidArgumentException( "Minute is out of range" )
		  end if
		  mMinute = minute
		  
		  if second < 0 or second >= 60 then
		    raise new InvalidArgumentException( "Second is out of range" )
		  end if
		  mSecond = second
		  
		  if nanosecond < 0 or nanosecond >= kBillion then
		    raise new InvalidArgumentException( "Nanosecond is out of range" )
		  end if
		  mNanosecond = nanosecond
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(copyFrom As M_TOML.LocalTime)
		  Constructor copyFrom.Hour, copyFrom.Minute, copyFrom.Second, copyFrom.Nanosecond
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromString(timeString As String) As M_TOML.LocalTime
		  var match as RegExMatch = M_TOML.RxTimeString.Search( timeString )
		  if match is nil then
		    raise new InvalidArgumentException( "Must in in format HH:MM:SS or MHH:MM:SS.mmmmmmm" )
		  end if
		  
		  return M_TOML.RegExMatchToLocalTime( match )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Now() As M_TOML.LocalTime
		  var now as DateTime = DateTime.Now
		  return new M_TOML.LocalTime( now.Hour, now.Minute, now.Second, now.Nanosecond )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Convert() As String
		  return ToString
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mHour
			End Get
		#tag EndGetter
		Hour As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mHour As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMinute
			  
			End Get
		#tag EndGetter
		Minute As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mMinute As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mNanosecond As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mSecond As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mSecondsFromMidnight As Double = -1.0
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( Hidden ) Private mStringValue As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mNanosecond
			  
			End Get
		#tag EndGetter
		Nanosecond As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSecond
			End Get
		#tag EndGetter
		Second As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mSecondsFromMidnight < 0.0 then
			    var billion as double = kBillion
			    var ns as double = Nanosecond
			    ns = ns / billion
			    
			    mSecondsFromMidnight = ( Hour * 60.0 * 60.0 ) + ( Minute * 60.0 ) + Second + ns
			  end if
			  
			  return mSecondsFromMidnight
			  
			End Get
		#tag EndGetter
		SecondsFromMidnight As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mStringValue = "" then
			    const kColon as string = ":"
			    
			    mStringValue = Hour.ToString( "00" ) + kColon + Minute.ToString( "00" ) + kColon + Second.ToString( "00" )
			    
			    if Nanosecond > kMillion then
			      var s as double = Nanosecond / kBillion
			      var iµs as integer = s * kMillion
			      s = iµs / kMillion
			      mStringValue = mStringValue + s.ToString( ".0#####" )
			    end if
			  end if
			  
			  return mStringValue
			  
			End Get
		#tag EndGetter
		ToString As String
	#tag EndComputedProperty


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
		#tag ViewProperty
			Name="Hour"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Minute"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Nanosecond"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Second"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SecondsFromMidnight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ToString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
