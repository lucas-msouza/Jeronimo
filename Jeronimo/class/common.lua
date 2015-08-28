-- Funções Comumns

local C = {}

function C.btnAnimation( self )

	transition.scaleTo(  self.target, {xScale = 1.1, yScale = 1.1, time = 100, 
		onComplete = function ( )
				transition.scaleTo(  self.target, {xScale=1, yScale =1 , time= 100} )
		end} )

	timer.performWithDelay( 500 , self.target.action )

end


return C