$1::
Loop 
{
If GetKeyState("1", "P"){
MouseGetPos, x1, y1 
PixelGetColor, color1, %x1%, %y1%
sleep,10
PixelGetColor, color2, %x1%, %y1%
	If (color1 = color2)
	        {
		return
		}

	Else	{
		send, {LButton down}
		sleep, 50
		send, {LButton down}
		}}
else{
break
}}