#tag Class
Protected Class InlineDictionary
Inherits Dictionary
	#tag Method, Flags = &h21
		Private Shared Function CaseDelegate(key1 As Variant, key2 As Variant) As Integer
		  if key1.Type <> Variant.TypeString or key1.Type <> key2.Type then
		    return key1.Type - key2.Type
		  end if
		  
		  return StrComp( key1.StringValue, key2.StringValue, 0 )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  self.Constructor( AddressOf CaseDelegate )
		End Sub
	#tag EndMethod


End Class
#tag EndClass
