package proxy
{
    import vo.IVO;

    /**
     * 
     * @author y.vircowskiy
     * Интерфейс прокси данных, которые могут быть модифицированы
     * в процессе работы приложения
     * 
     */
    
    public interface IVariableDataProxy
    {
        function saveData(immediately:Boolean=false):void;          //< Записать текущее состояние
        function updateChild(child:IVO):void;                       //< Обновить указанный дочерний объект
    }
}