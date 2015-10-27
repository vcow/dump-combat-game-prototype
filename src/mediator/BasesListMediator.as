package mediator
{
	import mx.collections.ArrayCollection;
	
	import command.data.RenameCmdData;
	
	import dictionary.BasesDict;
	import dictionary.Const;
	
	import events.BaseEvent;
	import events.BasesListEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import proxy.BasesListProxy;
	
	import views.protoBasesView;
	
	import vo.BaseTemplVO;
	import vo.BaseVO;
	import vo.RuinVO;
	import vo.TargetVO;
	
	public class BasesListMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "basesListMediator";
		
		private var _basesListProxy:BasesListProxy;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BasesListMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			applyViewComponent();
		}
		
        /**
         * Флаг, указывающий, что это первая база игрока
         */
        public function get isFirstBase():Boolean
        {
            return basesListProxy.getBasesList().length == 0;
        }
		
		/**
		 * Источник данных для списка руин
		 */
		public function get ruinsDataProvider():ArrayCollection
		{
			var ruins:Array = [];
			for each (var ruinVO:RuinVO in basesListProxy.getRuinsList())
				ruins.push(ruinVO);
			
			ruins.sortOn("ruinId");
			return new ArrayCollection(ruins);
		}
        
        /**
         * Обновить список баз
         * @param type тип отображаемых баз
         */
        public function updateList(type:String):void
        {
            if (!basesView)
                return;
            
            var bases:Array = [];
            
            switch (type)
            {
                case "my":
                    for each (var baseVO:BaseVO in basesListProxy.getBasesList())
                        bases.push({ label: baseVO.baseName, id: baseVO.baseId });
                    break;
                case "enemy":
                    for each (var targetVO:TargetVO in basesListProxy.getTargetsList())
                        bases.push({ label: targetVO.targetName, id: targetVO.targetId });
                    break;
                case "ruin":
                    for each (var ruinVO:RuinVO in basesListProxy.getRuinsList())
                    {
                        var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(ruinVO.ruinId);
                        if (baseTempl && baseTempl.baseRuin)
                            bases.push({ label: baseTempl.baseRuin.ruinName, id: baseTempl.baseId });
                    }
                    break;
            }
            
            bases.sortOn("baseName");
            basesView.basesList = new ArrayCollection(bases);
        }
		
		protected function get basesView():protoBasesView
		{
			return viewComponent as protoBasesView;
		}
		
		protected function get basesListProxy():BasesListProxy
		{
			if (!_basesListProxy)
				_basesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
			
			return _basesListProxy;
		}
		
		/**
		 * Освободить текущий визуальный компонент
		 */
		private function releaseViewComponent():void
		{
			if (!basesView)
				return;
			
			// TODO: Удалить все обработчики событий, если таковые были установлены
			
			basesView.removeEventListener(BasesListEvent.CREATE_BASE, createBaseHandler);
			basesView.removeEventListener(BaseEvent.RENAME, renameBaseHandler);
			
			// /TODO
		}
		
		/**
		 * Инициализировать текущий визуальный компонент
		 */
		private function applyViewComponent():void
		{
			if (!basesView)
				return;
			
			// TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
			
			basesView.buildNewBaseAvailable = basesListProxy.getRuinsList().length > 0;
			
			basesView.addEventListener(BasesListEvent.CREATE_BASE, createBaseHandler, false, 0, true);
			basesView.addEventListener(BaseEvent.RENAME, renameBaseHandler, false, 0, true);
            
            updateList("my");
			
			// /TODO
		}
		
		/**
		 * Обработчик запроса на создание новой базы
		 * @param event событие
		 */
		private function createBaseHandler(event:BasesListEvent):void
		{
			var ruinVO:RuinVO = event.valueObject as RuinVO;
			if (ruinVO)
				sendNotification(Const.CREATE_NEW_BASE, ruinVO.ruinId);
		}
		
		/**
		 * Обработчик запроса на переименование базы
		 * @param event событие
		 */
		private function renameBaseHandler(event:BaseEvent):void
		{
			sendNotification(Const.RENAME_BASE, new RenameCmdData(event.baseId, event.data.toString()));
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
			return [ Const.NEW_BASE_CREATED, Const.TARGET_FOUND, Const.BASE_RENAMED ];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case Const.NEW_BASE_CREATED:
					// После постройки базы изменился список баз и возможно исчезла возможность строить новые базы
					if (basesView)
					{
						basesView.updateList();
						basesView.buildNewBaseAvailable = basesListProxy.getRuinsList().length > 0;
						
						basesView.renameBase(notification.getBody() as BaseVO);
					}
					break;
				case Const.BASE_RENAMED:
                case Const.TARGET_FOUND:
					// После переименования базы или нахождения вражеской базы изменился список баз
					if (basesView)
						basesView.updateList();
					break;
			}
		}
	}
}