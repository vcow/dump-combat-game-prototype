package managers.data
{
    /**
     * 
     * @author y.vircowskiy
     * Интерфейс данных для порезки изображения
     * 
     */
    public interface IImageClipData
    {
        function get width():Number;            //< Ширина изображения
        function get height():Number;           //< Высота изображения
        
        function get left():Number;             //< Левая граница порезки
        function get top():Number;              //< Верхняя граница порезки
        function get right():Number;            //< Правая граница порезки
        function get bottom():Number;           //< Нижняя граница порезки
    }
}