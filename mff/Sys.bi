Namespace My
	Namespace Sys
		Function Name As String
			#If __Fb_linux__ 
				Return "Linux"
			#Else
				Return "Windows"
			#Endif
		End Function
		
		Function Version As String
			#If __Fb_linux__ 
				
			#Else
				
			#Endif
		End Function
	End Namespace
End Namespace
