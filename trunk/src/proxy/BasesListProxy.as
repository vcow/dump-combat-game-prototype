package proxy
{
	
	import dictionary.DefaultsDict;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.BaseVO;
	import vo.BasesListVO;
	import vo.IVO;
	import vo.RuinVO;
	import vo.TargetVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Прокси Списка баз
	 * 
	 */
	
	public class BasesListProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "basesProxy";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BasesListProxy(data:BasesListVO=null)
		{
			super(NAME, data);
		}
		
		public function get basesListVO():BasesListVO
		{
			return getData() as BasesListVO;
		}
		
		/**
		 * Получить список своих баз
		 * @return список баз
		 */
		public function getBasesList():Vector.<BaseVO>
		{
			var res:Vector.<BaseVO> = new Vector.<BaseVO>();
			for each (var value:IVO in basesListVO.children)
			{
				if (value.name == BaseVO.NAME)
					res.push(BaseVO(value));
			}
			return res;
		}
		
		/**
		 * Получить список вражеских баз
		 * @return список баз
		 */
		public function getTargetsList():Vector.<TargetVO>
		{
			var res:Vector.<TargetVO> = new Vector.<TargetVO>();
			for each (var value:IVO in basesListVO.children)
			{
				if (value.name == TargetVO.NAME)
					res.push(TargetVO(value));
			}
			return res;
		}
		
		/**
		 * Получить список разрушенных баз, которые могут быть использованы
		 * для строительства новой базы
		 * @return список руин
		 */
		public function getRuinsList():Vector.<RuinVO>
		{
			var res:Vector.<RuinVO> = new Vector.<RuinVO>();
			for each (var value:IVO in basesListVO.children)
			{
				if (value.name == RuinVO.NAME)
					res.push(RuinVO(value));
			}
			return res;
		}
		
		/**
		 * Вспомогательная функция, обновляет данные о базах в ApplicationVO
		 * @param save сохранить обновленные данные
		 */
		private function updateApplicationVO(save:Boolean=true):void
		{
			var appDataProxy:AppDataProxy = this.facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
			
			if (!appDataProxy)
				throw Error("Application Data Proxy must be specified.");
			
			appDataProxy.updateChild(basesListVO, save);
		}
		
		//----------------------------------
		//  Proxy
		//----------------------------------
		
		override public function getData():Object
		{
			if (!data)
			{
				var appDataProxy:AppDataProxy = this.facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
				var value:BasesListVO = appDataProxy ? appDataProxy.getChildByName(BasesListVO.NAME) as BasesListVO : null;
				
				if (!value)
					value = DefaultsDict.getInstance().basesList;
				
				setData(value);
				updateApplicationVO(false);
			}
			
			return data;
		}
	}
}