package vo
{
	import dictionary.CharacteristicsDict;
	import dictionary.Const;
	
	import facade.ProtoFacade;
	
	import helpers.ResourcesHelper;
	
	import managers.EventOut;
	
	import proxy.PersonsProxy;
	
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
		private var _person:PersonVO;
		
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
		}
		
		public function get employeeProfessionId():uint
		{
			return _employeeProfessionId;
		}
		
		public function get professionDesc():ProfessionDescVO
		{
			return _professionDesc;
		}
		
		public function get person():PersonVO
		{
			if (!_person)
				_person = PersonsProxy(ProtoFacade.getInstance().retrieveProxy(PersonsProxy.NAME)).getPersonById(employeePersonId);
			return _person;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override public function event(eventId:String, out:EventOut=null):void
		{
			if (eventId == _salaryEventId)
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
	