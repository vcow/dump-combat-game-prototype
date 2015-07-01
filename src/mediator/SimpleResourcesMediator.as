package mediator
{
	import helpers.ResourcesHelper;
	
	import dictionary.Const;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.ui.SimpleResourcesView;
	
	import vo.ResourceDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Медиатор для плашки, показывающей количество еды и денег
	 * (упрощенное отображение ресурсов)
	 * 
	 */
	
	public class SimpleResourcesMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "simpleResourcesMediator";
		
		private var _resourcesDecor:ResourcesHelper;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function SimpleResourcesMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get simpleResourcesView():SimpleResourcesView
		{
			return viewComponent as SimpleResourcesView;
		}
		
		protected function get resourcesDecor():ResourcesHelper
		{
			if (!_resourcesDecor)
				_resourcesDecor = new ResourcesHelper();
			
			return _resourcesDecor;
		}
		
		/**
		 * Освободить текущий визуальный компонент
		 */
		private function releaseViewComponent():void
		{
			if (!simpleResourcesView)
				return;
			
			// TODO: Удалить все обработчики событий, если таковые были установлены
		}
		
		/**
		 * Инициализировать текущий визуальный компонент
		 */
		private function applyViewComponent():void
		{
			if (!simpleResourcesView)
				return;
			
			// TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
			
			simpleResourcesView.cashCount = resourcesDecor.getResource(ResourceDescVO.CASH);
			simpleResourcesView.foodCount = resourcesDecor.getResource(ResourceDescVO.FOOD);
			
			// /TODO
		}
		
		//----------------------------------
		//  Mediator
		//----------------------------------
		
		override public function setViewComponent(viewComponent:Object):void
		{
			releaseViewComponent();
			super.setViewComponent(viewComponent);
			applyViewComponent();
		}
		
		override public function listNotificationInterests():Array
		{
			return [ Const.RESOURCES_CHANGED ];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.RESOURCES_CHANGED:
					// Изменилось количество ресурсов
					if (simpleResourcesView)
					{
						simpleResourcesView.cashCount = resourcesDecor.getResource(ResourceDescVO.CASH);
						simpleResourcesView.foodCount = resourcesDecor.getResource(ResourceDescVO.FOOD);
					}
					break;
			}
		}
	}
}