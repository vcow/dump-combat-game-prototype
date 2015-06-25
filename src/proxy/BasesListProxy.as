package proxy
{
	
	import dictionary.DefaultsDict;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.BaseVO;
	import vo.BasesVO;
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
		
		public function BasesListProxy(data:BasesVO=null)
		{
			super(NAME, data);
		}
		
		public function get basesListVO():BasesVO
		{
			return getData() as BasesVO;
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
		 * Получить базу, вражескую базу или руины
		 * @param baseId идентификатор запрашиваемого объекта
		 * @return база, вражеская база или руины, соответстсвующие идентификатору
		 */
		public function getBaseById(baseId:String):IVO
		{
			for each (var baseVO:BaseVO in getBasesList())
			{
				if (baseVO.baseId == baseId)
					return baseVO;
			}
			
			for each (var targetVO:TargetVO in getTargetsList())
			{
				if (targetVO.targetId == baseId)
					return targetVO;
			}
			
			for each (var ruinVO:RuinVO in getRuinsList())
			{
				if (ruinVO.ruinId == baseId)
					return ruinVO;
			}
			
			return null;
		}
		
		//----------------------------------
		//  Proxy
		//----------------------------------
		
		override public function getData():Object
		{
			if (!data)
			{
				var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
				var value:BasesVO = appDataProxy.getChildByName(BasesVO.NAME) as BasesVO;
				
				if (!value)
					value = DefaultsDict.getInstance().basesList;
				
				setData(value);
                
                appDataProxy.updateChild(basesListVO);
			}
			
			return data;
		}
	}
}