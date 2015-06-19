package vo
{
	import mx.resources.ResourceManager;
	
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
		 * Возвращает XML-объект, представляющий этот Value Object,
		 * должен быть переопределен в производном классе для добавления полей
		 * @return XML-объект
		 */
		protected function getSelfXMLObject():XML
		{
			return <{_name}/>;
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
			
			for each (var child:XML in data.children())
			{
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
					case RuinDefVO.NAME: value = new RuinDefVO(); break;
					case StoreVO.NAME: value = new StoreVO(); break;
					case PersonnelVO.NAME: value = new PersonnelVO(); break;
                    case PersonVO.NAME: value = new PersonVO(); break;
                    case EmployeeVO.NAME: value = new EmployeeVO(); break;
                    case EventDescVO.NAME: value = new EventDescVO(); break;
					
					// /TODO
					
					default: throw Error("Undefined item");
				}
				
				value.deserialize(child);
				_children.push(value);
			}
			
			return true;
		}
	}
}