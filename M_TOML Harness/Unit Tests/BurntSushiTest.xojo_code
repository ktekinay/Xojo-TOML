#tag Class
Protected Class BurntSushiTest
	#tag Method, Flags = &h0
		Sub Constructor(f As FolderItem)
		  if f.Name.EndsWith( ".toml" ) then
		    TOMLFolderItem = f
		    JSONFolderItem = f.Parent.Child( f.Name.Replace( ".toml", ".json" ) )
		  elseif f.Name.EndsWith( ".json" ) then
		    JSONFolderItem = f
		    TOMLFolderItem = f.Parent.Child( f.Name.Replace( ".json", ".toml" ) )
		  end if
		  
		  if TOMLFolderItem is nil or not TOMLFolderItem.Exists then
		    raise new InvalidArgumentException
		  end if
		  
		  if JSONFolderItem isa object and not JSONFolderItem.Exists then
		    JSONFolderItem = nil
		    
		  elseif JSONFolderItem isa object then
		    var json as string = TextFileContents( JSONFolderItem )
		    ExpectedDictionary = ParseJSON( json )
		    ExpectedDictionary = FixDictionary( ExpectedDictionary )
		    
		  end if
		  
		  Name = TOMLFolderItem.Name.Left( TOMLFolderItem.Name.Length - 5 )
		  TOML = TextFileContents( TOMLFolderItem )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FixDictionary(fixIt As Variant) As Variant
		  var dict as Dictionary
		  if fixIt isa Dictionary then
		    dict = fixIt
		    
		    if dict.KeyCount = 2 and dict.HasKey( "type" ) and dict.HasKey( "value" ) then
		      var type as string = dict.Value( "type" )
		      var value as string = dict.Value( "value" )
		      
		      var trueValue as variant
		      select case type
		      case "integer"
		        trueValue = value.ToInteger
		      case "bool"
		        trueValue = value = "true"
		      case "float"
		        trueValue = value.ToDouble
		      case "string"
		        #if TargetWindows then
		          value = value.ReplaceAll( EndOfLine.UNIX, EndOfLine.Windows )
		        #endif
		        trueValue = value
		      case "datetime", "datetime-local"
		        trueValue = ParseDateTime( value )
		      case "date-local"
		        var parts() as string = value.Split( "-" )
		        trueValue = new M_TOML.LocalDateTime( parts( 0 ).ToInteger, parts( 1 ).ToInteger, parts( 2 ).ToInteger )
		      case "time-local"
		        trueValue = M_TOML.LocalTime.FromString( value )
		      case else
		        raise new RuntimeException
		      end select
		      
		      return trueValue
		    end if
		    
		    var keys() as variant = dict.Keys
		    var values() as variant = dict.Values
		    
		    for i as integer = 0 to keys.LastIndex
		      var value as variant = values( i )
		      var key as string = keys( i )
		      dict.Value( key ) = FixDictionary( value )
		    next
		    
		  elseif fixIt.IsArray then
		    var arr() as variant = fixIt
		    for i as integer = 0 to arr.LastIndex
		      arr( i ) = FixDictionary( arr( i ) )
		    next
		    fixIt = arr
		    
		  end if
		  
		  return fixIt
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseDateTime(s As String) As DateTime
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = "(?mi-Us)\A(\d{4})-(\d{2})-(\d{2})[T\x20](\d{2}):(\d{2}):(\d{2})(\.\d+)?(?|(Z)|([-+]\d{2}):(\d{2}))?\z"
		  end if
		  
		  var dt as DateTime
		  
		  var match as RegExMatch = rx.Search( s )
		  
		  var year as integer = match.SubExpressionString( 1 ).ToInteger
		  var month as integer = match.SubExpressionString( 2 ).ToInteger
		  var day as integer = match.SubExpressionString( 3 ).ToInteger
		  var hour as integer = match.SubExpressionString( 4 ).ToInteger
		  var minute as integer = match.SubExpressionString( 5 ).ToInteger
		  var second as integer = match.SubExpressionString( 6 ).ToInteger
		  
		  var ns as integer
		  if match.SubExpressionCount >= 8 and match.SubExpressionString( 7 ) <> "" then
		    var nsd as double = match.SubExpressionString( 7 ).ToDouble
		    ns = nsd * 1000000000.0
		  end if
		  
		  static gmt as new TimeZone( 0 )
		  var tz as TimeZone
		  
		  var hasTZ as boolean
		  
		  if match.SubExpressionCount = 9 then
		    hasTZ = true
		    
		    var offsetTime as string = match.SubExpressionString( 8 )
		    if offsetTime = "Z" then
		      tz = gmt
		      
		    elseif offsetTime <> "" then
		      var parts() as string = offsetTime.Split( ":" )
		      var offsetSecs as integer = ( parts( 0 ).ToInteger  * 60 * 60 ) + ( parts( 1 ).ToInteger * 60 )
		      tz = new TimeZone( offsetSecs )
		      
		    end if
		  end if
		  
		  if hasTZ then
		    dt = new DateTime( year, month, day, hour, minute, second, ns, tz )
		  else
		    dt = new M_TOML.LocalDateTime( year, month, day, hour, minute, second, ns )
		  end if
		  
		  return dt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TextFileContents(f As FolderItem) As String
		  var tis as TextInputStream = TextInputStream.Open( f )
		  var result as string = tis.ReadAll( Encodings.UTF8 )
		  tis.Close
		  return result.ReplaceLineEndings( EndOfLine )
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		ExpectedDictionary As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		JSONFolderItem As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TOML As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TOMLFolderItem As FolderItem
	#tag EndProperty


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
			Name="TOML"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
