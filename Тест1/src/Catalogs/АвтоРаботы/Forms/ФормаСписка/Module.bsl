

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Отказ = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ДокументСсылка.ЗаказНаряд") Тогда

		Работа = Новый Структура();
		Работа.Вставить("Работа", Элементы.Список.ТекущаяСтрока);
		ДобавитьВЗаказНарядНаСервере(ВыбранноеЗначение, Работа, Отказ);
		
		
		Если Не Отказ Тогда
			
			Если НЕ РежимМножественнногоВыбора Тогда
				ПараметрыФормы = Новый Структура();
				ПараметрыФормы.Вставить("Работы_НомерСтроки", Работа.НомерСтроки);
				ПараметрыФормы.Вставить("Ключ", ВыбранноеЗначение);
				ОткрытьФорму("Документ.ЗаказНаряд.ФормаОбъекта", ПараметрыФормы);
			Иначе
				Сообщить(СтрШаблон("Добавлено ранее в строку %1", Работа.НомерСтроки));
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ИмяТаблицы



#КонецОбласти

#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура ДобавитьВЗаказНарядИОткрыть(Команда)
	
	
	ДобавитьВЗаказНаряд(Команда);
	РежимМножественнногоВыбора = Ложь;
	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьВЗаказНаряд(Команда)
	
	ПараметрыФормы = Новый Структура("РежимВыбора", Истина);
	Отбор = Новый Структура();
	Отбор.Вставить("ДатаОкончания", '00010101');
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	РежимМножественнногоВыбора = Истина;
	ОткрытьФорму("Документ.ЗаказНаряд.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВЗаказНарядНаСервере(ДокументЗаказНаряд, Работа, Отказ)
	
	
	ДокОбъект = ДокументЗаказНаряд.ПолучитьОбъект();
	
	
	
	ОтборСтрок = Новый Структура();
	ОтборСтрок.Вставить("Работа", Работа.Работа);
	НайденныеСтроки = ДокОбъект.Работы.НайтиСтроки(ОтборСтрок);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		НомерСтроки = НайденныеСтроки[0].НомерСтроки;
		//Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, "Товар");
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		//	СтрШаблон("Эта партия уже добавлена (см. строку №%1)",
		//		НомерСтроки),
		//	ДокОбъект,
		//	Поле,
		//	"Объект"
		//);
		
		Работа.Вставить("НомерСтроки", НомерСтроки);
		Возврат	
	КонецЕсли;
	
	СтруктураСтроки = Новый Структура("Работа,Цена,Нормочас,Количество,ВремяПлан");
	ЗаполнитьЗначенияСвойств(СтруктураСтроки, ОтборСтрок);
	//РаботаПриИзмененииСервер(СтруктураСтроки);
	СтруктураСтроки.Вставить("ТипНаценки", ДокОбъект.ТипНаценки);

	дт_АвтосервисВызовСервера.РаботаПриИзменении(СтруктураСтроки);
	
	НоваяСтрока = ДокОбъект.Работы.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураСтроки);
	
	дт_АвтосервисКлиентСервер.ОбработкаИзмененияСтроки(ДокОбъект, "Работы", НоваяСтрока);
	
	
	Попытка
	
		ДокОбъект.Записать();
		Работа.Вставить("НомерСтроки", НоваяСтрока.НомерСтроки);
	
	Исключение
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("Не удалось записать документ %1. %2",
				ДокОбъект,
				ОписаниеОшибки()),
			,
			,
			,
			Отказ
		);
			
	КонецПопытки;
	
	
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти
