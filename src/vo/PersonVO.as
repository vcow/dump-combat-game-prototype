package vo
{
	import mx.resources.ResourceManager;
	
	import command.data.GameEventCmdData;
	
	import dictionary.Const;
	import dictionary.ProfessionsDict;
	
	import helpers.ResourcesHelper;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object персонажа
	 * 
	 */
	
	public class PersonVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "person";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var personId:String;                     //< Уникальный идентификатор персонажа
        public var personName:String;                   //< Имя персонажа
        public var personGender:String;                 //< Пол персонажа (m/f)
        public var personImage:String;                  //< Изображение персонажа
        public var personInactive:uint;                 //< Количество ходов, которое персонаж пребывает в неактивном состоянии
        
        private var _personProfessionId:String;         //< Идентификатор профессии персонажа
        
        private var _professionDesc:ProfessionDescVO;
        private var _salaryEventId:String;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function PersonVO()
		{
			super(NAME);
		}
        
        public function set personProfessionId(value:String):void
        {
            if (value == _personProfessionId)
                return;
            
            _personProfessionId = value;
            
            _professionDesc = ProfessionsDict.getInstance().getProfession(_personProfessionId);
            var salary:PriceVO = _professionDesc.professionSalary;
            _salaryEventId = salary ? salary.priceEventId : "";
        }
        
        public function get personProfessionId():String
        {
            return _personProfessionId;
        }
        
        public function get professionDesc():ProfessionDescVO
        {
            return _professionDesc;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
        
        override public function event(eventId:String, data:Object=null, out:GameEventCmdData=null):void
        {
            if (_salaryEventId && eventId == _salaryEventId)
            {
                // Событие, по которому выплачивается зарплата для персонажа
                if (out)
                {
                    var outData:Array = out.commonOut[Const.CHANGE_RESOURCES] as Array;
                    var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                    
                    var commonFee:PriceVO;
                    if (outData)
                        commonFee = resourcesDecor.joinPrice(resourcesDecor.joinPrice.apply(this, outData),
                            resourcesDecor.invertPrice(professionDesc.professionSalary));
                    else
                        commonFee = resourcesDecor.invertPrice(professionDesc.professionSalary);
                    
                    if (resourcesDecor.isEnoughResources(resourcesDecor.separatePrice(commonFee, true)[1]))
                    {
                        out.commonOut[Const.CHANGE_RESOURCES] = [ commonFee ];
                        
                        if (personInactive > 0)
                        {
                            // Сейчас реализовано так, что персонаж просто возобновляет деятельность,
                            // как вариант, можно предусмотреть выплатить ему долг по зарплате
                            personInactive = 0;
                            
                            var message:String = ResourceManager.getInstance().getString("messages", "worker.resumed",
                                [ professionDesc.professionName, personName ]);
                            sendNotification(Const.SEND_GAME_MESSAGE, message, Const.MESSAGE);
                        }
                    }
                    else
                    {
                        // Сократить персонаж, или отправить в неоплачиваемый отпуск
                        if (personInactive == 0)
                        {
                            message = ResourceManager.getInstance().getString("messages", "idle.worker",
                                [ professionDesc.professionName, personName ]);
                            sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                        }
                        
                        personInactive += 1;
                    }
                }
            }
            else
            {
                super.event(eventId, data, out);
            }
        }
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = personId || Const.NO_GUID;
            res.@name = personName;
            res.@gender = personGender;
            res.@profession = personProfessionId;
            
            if (personInactive)
                res.@inactive = personInactive;
            
            if (personImage)
                res.@image = personImage;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			personId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            personName = data.hasOwnProperty("@name") ? data.@name.toString() : "";
            personGender = data.hasOwnProperty("@gender") ? data.@gender.toString() : Const.MALE;
            personImage = data.hasOwnProperty("@image") ? data.@image.toString() : null;
            personProfessionId = data.hasOwnProperty("@profession") ? data.@profession.toString() : "";
            personInactive = data.hasOwnProperty("@inactive") ? uint(data.@inactive) : 0;
			
			// /TODO
			
			return true;
		}
	}
}
	