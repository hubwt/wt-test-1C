#Область ПрограммныйИнтерфейс

Процедура УстановитьПоказателиСотрудников() Экспорт
	ТДата = ТекущаяДата(); 
	ВремяСобытия = дт_ПоказателиСотрудниковВызовСервера.ПолучитьВремяУстановкиПоказателей();
	ДатаСобытия = НачалоДня(ТДата) + Час(ВремяСобытия) * 3600 + Минута(ВремяСобытия) * 60;
	
	Если ТДата >= ДатаСобытия Тогда
		
		ОтключитьОбработчикОжидания("УстановитьПоказателиСотрудников");
		
		дт_ПоказателиСотрудниковКлиент.ПроверитьОткрытьФормуУстановкиПоказателей(ТДата);
		
	КонецЕсли; 
		
КонецПроцедуры


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти