#tag Class
Protected Class LongTOMLTests
Inherits TOMLTestGroupBase
	#tag Method, Flags = &h21
		Private Function AreSameArrays(arr1() As Variant, arr2() As Variant) As Boolean
		  if arr1.Count <> arr2.Count then
		    return false
		  end if
		  
		  for i as integer = 0 to arr1.LastIndex
		    var val1 as variant = arr1( i )
		    var val2 as variant = arr2( i )
		    if not AreSameValues( val1, val2 ) then
		      return false
		    end if
		  next
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AreSameDictionaries(d1 As Dictionary, d2 As Dictionary) As Boolean
		  if d1.KeyCount <> d2.KeyCount then
		    return false
		  end if
		  
		  var keys1() as string = StringKeys( d1 )
		  var keys2() as string = StringKeys( d2 )
		  var values1() as variant = d1.Values
		  var values2() as variant = d2.Values
		  
		  keys1.SortWith values1
		  keys2.SortWith values2
		  
		  for i as integer = 0 to keys1.LastIndex
		    var k1 as string = keys1( i )
		    var k2 as string = keys2( i )
		    
		    if StrComp( k1, k2, 0 ) <> 0 then
		      return false
		    end if
		    
		    var val1 as variant = values1( i )
		    var val2 as variant = values2( i )
		    if not AreSameValues( val1, val2 ) then
		      return false
		    end if
		  next
		  
		  return true
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AreSameValues(v1 As Variant, v2 As Variant) As Boolean
		  v1 = ToBestType( v1 )
		  v2 = ToBestType( v2 )
		  
		  var v1Type as integer = v1.Type
		  var v2Type as integer = v2.Type
		  
		  if v1Type <> v2Type then
		    System.DebugLog v1Type.ToString + ", " + v2Type.ToString
		    return false
		  end if
		  
		  var result as boolean
		  
		  if v1.Type = Variant.TypeObject and v1 isa Dictionary then
		    result = AreSameDictionaries( v1, v2 )
		    
		  elseif v1.IsArray and v2.IsArray then
		    result = AreSameArrays( v1, v2 )
		    
		  elseif v1.Type = Variant.TypeObject then
		    break
		    
		  else
		    result = StrComp( v1.StringValue, v2.StringValue, 0 ) = 0
		    
		  end if
		  
		  #if DebugBuild then
		    if result = false then
		      result = result // A place to break
		    end if
		  #endif
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BigTOMLTest()
		  var fromTOML as Dictionary = ParseTOML_MTC( kBigTOML )
		  var fromJSON as Dictionary = ParseJSON( kBigJSON )
		  var result as boolean = AreSameDictionaries( fromTOML, fromJSON )
		  Assert.IsTrue result
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StringKeys(d As Dictionary) As String()
		  var stringKeys() as string 
		  var keys() as variant = d.Keys
		  for each k as variant in keys
		    stringKeys.Add k
		  next
		  return stringKeys
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToBestType(v As Variant) As Variant
		  select case v.Type
		  case Variant.TypeInt32, Variant.TypeInt64, Variant.TypeInteger
		    var i as integer = v
		    v = i
		    
		  case Variant.TypeSingle
		    var d as double = v
		    v = d
		    
		  case Variant.TypeText
		    var s as string = v.TextValue
		    v = s
		    
		  end select
		  
		  return v
		End Function
	#tag EndMethod


	#tag EndConstant

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