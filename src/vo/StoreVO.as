package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object склада
	 * 
	 */
	
	public class StoreVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "store";
		
		/**
		 * Добавить в склад содержимое другого склада
		 * @param store добавляемый склад
		 */
		public function append(store:StoreVO):void
		{
			var newResources:Vector.<ResourceVO> = new Vector.<ResourceVO>();
			
			for (var i:int = 0; i < store.numChildren; i++)
			{
                var src:ResourceVO = ResourceVO(store.getChildAt(i));
				var resourceNotFound:Boolean = true;
				for (var j:int = 0; j < numChildren; j++)
				{
                    var dest:ResourceVO = ResourceVO(getChildAt(j));
					if (dest.resourceId == src.resourceId)
					{
						dest.resourceCount += src.resourceCount;
						resourceNotFound = false;
						break;
					}
				}
				
				if (resourceNotFound)
					newResources.push(src.clone());
			}
			
			for each (dest in newResources)
				addChild(dest);
		}
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function StoreVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
	}
}