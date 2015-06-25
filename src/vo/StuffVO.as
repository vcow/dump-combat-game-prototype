package vo
{
    import flash.utils.ByteArray;
    
    import mx.utils.Base64Decoder;
    import mx.utils.Base64Encoder;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object персонажей
	 * 
	 */
	
	public class StuffVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "stuff";
        
        public var data:Object = {};
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function StuffVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            var res:XML = super.getSelfXMLObject();
            
            // TODO: Сериализовать специфичные поля
            
            var byteArray:ByteArray = new ByteArray();
            var base64:Base64Encoder = new Base64Encoder();
            
            byteArray.writeObject(data);
            base64.encodeBytes(byteArray);
            
            res.appendChild(base64.toString());
            
            // /TODO
            
            return res;
        }
		
		override public function deserialize(data:XML):Boolean
		{
			// TODO: десериализовать специфичные поля
            
            for each (var child:XML in data.children())
            {
                if (child.localName() == null)
                {
                    var raw:String = child.toString();
                    var base64:Base64Decoder = new Base64Decoder();
                    
                    base64.decode(raw);
                    
                    var byteArray:ByteArray = base64.toByteArray();
                    byteArray.position = 0;
                    this.data = byteArray.readObject();
                    
                    break;
                }
            }
            
            // /TODO
			
			return true;
		}
	}
}