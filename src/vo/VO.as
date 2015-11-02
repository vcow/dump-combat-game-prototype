package vo
{
	import mx.resources.ResourceManager;
	
	import facade.ProtoFacade;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Базовый класс Value Object с поддержкой сериализации в XML
	 * 
	 */
	
	public class VO implements IVO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];
		
		private var _name:String;
		protected var _children:Vector.<IVO> = new Vector.<IVO>();
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		/**
		 * Конструктор
		 * @param name уникальное имя Value Object, используется для сериализации
		 */
		public function VO(name:String)
		{
			name = name.split(/\W*/).join("_");
			
			if (!name)
				throw Error("Wrong Value Object name.");
			
			_name = name;
		}
		
		/**
		 * Клонировать объект
		 * @return копия объекта
		 */
		public function clone():VO
		{
			throw Error("Must be override in child object.");
			return null;
		}
        
        /**
         * Разослать внутриигровое событие всем дочерним объектам
         * @param eventId идентификатор внутриигрового события
         * @param data данные события
         * @param out объект, в котором могут быть возвращены дополнительные параметры из дочерних элементов
         */
        public function event(eventId:String, data:Object=null):void
        {
            for each (var value:VO in _children)
                value.event(eventId, data);
        }
        
        /**
         * Отправить нотификацию через фассад
         * @param notificationName название нотификации
         * @param body тело нотификации
         * @param type тип нотификации
         */
        final protected function sendNotification(notificationName:String, body:Object=null, type:String=null):void
        {
            ProtoFacade.getInstance().sendNotification(notificationName, body, type);
        }
		
		/**
		 * Возвращает XML-объект, представляющий этот Value Object,
		 * должен быть переопределен в производном классе для добавления полей
		 * @return XML-объект
		 */
		protected function getSelfXMLObject():XML
		{
			return <{_name}/>;
		}
        
        /**
         * Преобразовать XML в объект, где имя тэга является именем поля, а значение - значением поля
         * @param xml исходные данные
         * @return преобразованный объект
         */
        protected function parseAsObject(xml:XML):Object
        {
            if (xml.localName() == null)
                return xml.toString();
            
            var data:Object = {};
            var type:String = xml.hasOwnProperty("@type") ? xml.@type.toString().toLowerCase() : "";
            var fieldsCtr:int = 0;
            
            for each (var child:XML in xml.children())
            {
                if (child.localName() == null)
                {
                    switch (type)
                    {
                        case "int": return int(parseInt(child.toString()));
                        case "uint": return uint(parseInt(child.toString()));
                        case "float": return parseFloat(child.toString());
                    }
                    return child.toString();
                }
                else
                {
                    var name:String = child.localName().toString();
                    if (data.hasOwnProperty(name))
                        name += ++fieldsCtr;
                    data[name] = parseAsObject(child);
                }
            }
            
            return data;
        }
		
		/**
		 * Парсинг строкового значения, полученного из описания, это может быть
		 * как обычная строка, так и ключ ресурса в формате {key}
		 * @param rawData исходное значение 
		 * @return строковое значение
		 */
		public static function parseString(rawData:*, bundle:String):String
		{
			var tag:String = rawData.toString();
			if (tag.search(/^\{.+\}$/g) != -1)
			{
				tag = tag.replace(/^\{(.+)\}$/g, "$1");
				var res:String = ResourceManager.getInstance().getString(bundle, tag);
				return res ? res : tag;
			}
			return tag;
		}
		
		/**
		 * Сгенерировать уникальный id
		 * @return уникальный id, похожий на GUID
		 */
		public static function createGUID():String
		{
			var uid:Array = new Array(36);
			var index:int = 0;
			
			var i:int;
			var j:int;
			
			for (i = 0; i < 8; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
			}
			
			for (i = 0; i < 3; i++)
			{
				uid[index++] = 45;
				
				for (j = 0; j < 4; j++)
				{
					uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
				}
			}
			
			uid[index++] = 45;
			
			var time:Number = new Date().getTime();
			var timeString:String = ("0000000" + time.toString(16).toUpperCase()).substr(-8);
			
			for (i = 0; i < 8; i++)
			{
				uid[index++] = timeString.charCodeAt(i);
			}
			
			for (i = 0; i < 4; i++)
			{
				uid[index++] = ALPHA_CHAR_CODES[Math.floor(Math.random() *  16)];
			}
			
			return String.fromCharCode.apply(null, uid);
		}
		
		//----------------------------------
		//  IVO
		//----------------------------------
		
		public function get name():String
		{
			return _name;
		}
		
		public function get children():Vector.<IVO>
		{
			return _children;
		}
		
		public function serialize():XML
		{
			var res:XML = getSelfXMLObject();
			
			for each (var value:IVO in _children)
				res.appendChild(value.serialize());
			
			return res;
		}
		
		public function deserialize(data:XML):Boolean
		{
			_children.splice(0, _children.length);
			
			if (data.localName().toString() != _name)
				throw Error("Wrong application data file.");
			
            var children:XMLList = data.children();
            var childrenLen:int = children.length();
            
			for (var i:int = 0; i < childrenLen; i++)
			{
                var child:XML = children[i];
                
				var value:IVO = null;
				switch (child.localName().toString())
				{
					// TODO: Сюда добавить другие VO для десериализации
					
					case BaseVO.NAME: value = new BaseVO(); break;
					case BasesVO.NAME: value = new BasesVO(); break;
					case PriceVO.NAME: value = new PriceVO(); break;
					case ResourceVO.NAME: value = new ResourceVO(); break;
					case RuinVO.NAME: value = new RuinVO(); break;
					case TargetVO.NAME: value = new TargetVO(); break;
					case ModulesVO.NAME: value = new ModulesVO(); break;
					case ModuleVO.NAME: value = new ModuleVO(); break;
					case RuinTemplVO.NAME: value = new RuinTemplVO(); break;
					case StoreVO.NAME: value = new StoreVO(); break;
                    case UnlockedVO.NAME: value = new UnlockedVO(); break;
					case PersonnelVO.NAME: value = new PersonnelVO(); break;
                    case PersonVO.NAME: value = new PersonVO(); break;
                    case EmployeeVO.NAME: value = new EmployeeVO(); break;
                    case ArmyVO.NAME: value = new ArmyVO(); break;
                    case PersonsVO.NAME: value = new PersonsVO(); break;
                    case StuffVO.NAME: value = new StuffVO(); break;
                    case NotificationVO.NAME: value = new NotificationVO(); break;
                    case TriggersVO.NAME: value = new TriggersVO(); break;
                    case TriggerValueVO.NAME: value = new TriggerValueVO(); break;
                    case EventVO.NAME: value = new EventVO(); break;
                    case TimerVO.NAME: value = new TimerVO(); break;
                    case TimersVO.NAME: value = new TimersVO(); break;
                    case ConditionVO.NAME: value = new ConditionVO(); break;
                    case DataVO.NAME: value = new DataVO(); break;
                    case VisibilityVO.NAME: value = new VisibilityVO(); break;
                    case ResultVO.NAME: value = new ResultVO(); break;
                    case CompleteVO.NAME: value = new CompleteVO(); break;
                    case InvestigationsVO.NAME: value = new InvestigationsVO(); break;
                    case TriggerVO.NAME: value = new TriggerVO(); break;
                    case WorkerVO.NAME: value = new WorkerVO(); break;
                    case ResearchVO.NAME: value = new ResearchVO(); break;
                    case ProductionsVO.NAME: value = new ProductionsVO(); break;
                    case ProductionVO.NAME: value = new ProductionVO(); break;
                    case UnitVO.NAME: value = new UnitVO(); break;
                    case GarrisonVO.NAME: value = new GarrisonVO(); break;
                    case MercenaryVO.NAME: value = new MercenaryVO(); break;
                    case WeaponVO.NAME: value = new WeaponVO(); break;
                    case AmmoVO.NAME: value = new AmmoVO(); break;
                    case ArmorVO.NAME: value = new ArmorVO(); break;
                    case ModifiersVO.NAME: value = new ModifiersVO(); break;
                    case QuestDescVO.NAME: value = new QuestDescVO(); break;
                    case QuestDefVO.NAME: value = new QuestDefVO(); break;
                    case QuestsVO.NAME: value = new QuestsVO(); break;
                    case QuestVO.NAME: value = new QuestVO(); break;
                    case StepVO.NAME: value = new StepVO(); break;
                    case GiveBaseVO.NAME: value = new GiveBaseVO(); break;
                    case StepTargetsVO.NAME: value = new StepTargetsVO(); break;
                    case StepTargetVO.NAME: value = new StepTargetVO(); break;
                    case GameOverVO.NAME: value = new GameOverVO(); break;
                    case GiveQuestVO.NAME: value = new GiveQuestVO(); break;
                    case FindBaseVO.NAME: value = new FindBaseVO(); break;
                    case TimeoutVO.NAME: value = new TimeoutVO(); break;
                    case UiMessageVO.NAME: value = new UiMessageVO(); break;
                    case OkVO.NAME: value = new OkVO(); break;
                    case CancelVO.NAME: value = new CancelVO(); break;
                    case YesVO.NAME: value = new YesVO(); break;
                    case NoVO.NAME: value = new NoVO(); break;
                    case RaidsVO.NAME: value = new RaidsVO(); break;
                    case RaidVO.NAME: value = new RaidVO(); break;
                    case LevelVO.NAME: value = new LevelVO(); break;
					
					// /TODO
					
					default: throw Error("Undefined item <" + child.localName().toString() + "/>.");
				}
				
				value.deserialize(child);
				_children.push(value);
			}
			
			return true;
		}
	}
}