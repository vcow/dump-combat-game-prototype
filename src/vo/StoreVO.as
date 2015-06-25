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
			
			for each (var src:ResourceVO in store.children)
			{
				var resourceNotFound:Boolean = true;
				for each (var dest:ResourceVO in children)
				{
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
				children.push(dest);
		}
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function StoreVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
        override public function event(eventId:String):void
        {
            // Отсекаем ивенты для дочерних элементов за ненадобностью
        }
	}
}