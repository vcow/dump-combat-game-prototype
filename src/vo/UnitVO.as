package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object юнита
	 * 
	 */
	
	public class UnitVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "unit";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function UnitVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			
			// /TODO
			
			return true;
		}
	}
}