package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Интерфейс Value Object
	 * 
	 */
	
	public interface IVO
	{
		function get name():String;					//< Имя объекта
		function get children():Vector.<IVO>;		//< Дочерние элементы
		
		function serialize():XML;					//< Сериализовать представление объекта
		function deserialize(data:XML):Boolean;		//< Десериализовать представление объекта
	}
}