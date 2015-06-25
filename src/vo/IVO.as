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
        function get parent():IVO;                  //< Родительский VO
        
        function addChild(vo:IVO):IVO;              //< Добавить дочерний VO
        function removeChild(vo:IVO):IVO;           //< Удалить дочерний VO
        function removeChildAt(index:int):IVO;      //< Удалить дочерний VO из указанной позиции
        function removeAllChildren():int;           //< Удалить все дочерние VO
        
        function getChildAt(index:int):IVO;         //< Получить дочерний VO по индексу в массиве дочерних элементов
        function getChildIndex(vo:IVO):int;         //< Получить индекс дочернего VO в массиве дочерних элементов
        
		function get numChildren():int;             //< Количество дочерних объектов
		
		function serialize():XML;					//< Сериализовать представление объекта
		function deserialize(data:XML):Boolean;		//< Десериализовать представление объекта
	}
}