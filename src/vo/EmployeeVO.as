package vo
{
	import command.data.GameEventCmdData;
	
	import dictionary.CharacteristicsDict;
	import dictionary.Const;
	
	import helpers.ResourcesHelper;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object работника
	 * 
	 */
	
	public class EmployeeVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "employee";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var employeePersonId:String;				//< Уникальный идентификатор персонажа
		
		private var _employeeProfessionId:uint;			//< Идентификатор профессии персонажа
		
		private var _professionDesc:ProfessionDescVO;
		private var _salaryEventId:String;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EmployeeVO()
		{
			super(NAME);
		}
		
		public function set employeeProfessionId(value:uint):void
		{
			if (value == _employeeProfessionId)
				return;
			
			_employeeProfessionId = value;
			
			_professionDesc = CharacteristicsDict.getInstance().getProfession(_employeeProfessionId);
            var salary:PriceVO = _professionDesc.professionSalary;
            _salaryEventId = salary ? salary.priceEventId : "";
		}
		
		public function get employeeProfessionId():uint
		{
			return _employeeProfessionId;
		}
		
		public function get professionDesc():ProfessionDescVO
		{
			return _professionDesc;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override public function event(eventId:String, out:GameEventCmdData=null):void
		{
			if (_salaryEventId && eventId == _salaryEventId)
			{
				// Событие, по которому выплачивается зарплата для сотрудника
				if (out)
				{
					var data:Array = out.commonOut[Const.CHANGE_RESOURCES] as Array;
					var resourcesDecor:ResourcesHelper = new ResourcesHelper();
					
					var commonFee:PriceVO;
					if (data)
						commonFee = resourcesDecor.joinPrice(resourcesDecor.joinPrice.apply(this, data), resourcesDecor.invertPrice(professionDesc.professionSalary));
					else
						commonFee = resourcesDecor.invertPrice(professionDesc.professionSalary);
					
					if (resourcesDecor.isEnoughResources(resourcesDecor.separatePrice(commonFee, true)[1]))
					{
						out.commonOut[Const.CHANGE_RESOURCES] = [ commonFee ];
					}
					else
					{
						// Сократить сотрудника, или отправить в неоплачиваемый отпуск
					}
				}
			}
			else
			{
				super.event(eventId, out);
			}
		}
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = employeePersonId;
			res.@profession = employeeProfessionId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			employeePersonId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
			employeeProfessionId = data.hasOwnProperty("@profession") ? uint(data.@profession) : 0;
			
			// /TODO
			
			return true;
		}
	}
}
	