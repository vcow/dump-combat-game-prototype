package mediator
{
	import decorator.ResourcesDecor;
	
	import dictionary.Const;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxy.AppDataProxy;
	import proxy.BasesListProxy;
	
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
		
		private var _resourcesDecor:ResourcesDecor;
		
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
		
		protected function get resourcesDecor():ResourcesDecor
		{
			if (!_resourcesDecor)
				_resourcesDecor = new ResourcesDecor(BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)),
					AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)));
			
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
			
			simpleResourcesView.cashView.count = resourcesDecor.getResource(ResourceDescVO.CASH);
			simpleResourcesView.foodView.count = resourcesDecor.getResource(ResourceDescVO.FOOD);
			
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
			return [ Const.NEW_BASE_CREATED ];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.NEW_BASE_CREATED:
					// После постройки новой базы, вероятно, изменилось количество ресурсов
					if (simpleResourcesView)
					{
						simpleResourcesView.cashView.count = resourcesDecor.getResource(ResourceDescVO.CASH);
						simpleResourcesView.foodView.count = resourcesDecor.getResource(ResourceDescVO.FOOD);
					}
					break;
			}
		}
	}
}