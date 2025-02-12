
#Область ПрограммныйИнтерфейс


// Вывести штрихкод в табличный документ
//
// Параметры:
//  ТабличныйДокумент - ТабличныйДокумент - Табличный документ
//  Макет - Макет - Табличный документ
//  ОбластьМакета - ОбластьТабличногоДокумента - Область
//  Ссылка - ЛюбаяСсылка - Ссылка на документ из которого будет вычислен штрихкод
//
Процедура ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, Знач ОбластьМакета, Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыводитьШтрихкодВОтдельнуюОбласть = Ложь;
	Если Не ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакета) Тогда
		// Картинки штрихкода в этой области макета нет.
		
		Если Макет.Области.Найти("ОбластьШтрихкода") <> Неопределено Тогда
			
			// Проверить картинку штрихкода в области "Штрихкод"
			ОбластьМакетаШтрихкод = Макет.ПолучитьОбласть("ОбластьШтрихкода");
			Если ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакетаШтрихкод) Тогда
				ОбластьМакета = ОбластьМакетаШтрихкод;
				ВыводитьШтрихкодВОтдельнуюОбласть = Истина;
			Иначе
				Возврат;
			КонецЕсли;
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	//Если Не ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкодированиеПечатныхФормОбъектов") Тогда
		ОбластьМакета.Рисунки.Удалить(ОбластьМакета.Рисунки.КартинкаШтрихкода);
	//	Возврат;
	//КонецЕсли;
	
	//Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	//КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	//
	//ПараметрыШтрихкода = Новый Структура;
	//ПараметрыШтрихкода.Вставить("Ширина",          Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Ширина / КоличествоМиллиметровВПикселе));
	//ПараметрыШтрихкода.Вставить("Высота",          Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Высота / КоличествоМиллиметровВПикселе));
	//ПараметрыШтрихкода.Вставить("Штрихкод",        СокрЛП(ЧисловойКодПоСсылке(Ссылка)));
	//ПараметрыШтрихкода.Вставить("ТипКода",         4); // Code128
	//ПараметрыШтрихкода.Вставить("ОтображатьТекст", Ложь);
	//ПараметрыШтрихкода.Вставить("РазмерШрифта",    6);
	//
	//ОбластьМакета.Рисунки.КартинкаШтрихкода.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
	//
	Если ВыводитьШтрихкодВОтдельнуюОбласть Тогда
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПреобразоватьДесятичноеЧислоВШестнадцатиричнуюСистемуСчисления(Знач ДесятичноеЧисло)
	
	Результат = "";
	
	Пока ДесятичноеЧисло > 0 цикл
		ОстатокОтДеления = ДесятичноеЧисло % 16;
		ДесятичноеЧисло  = (ДесятичноеЧисло - ОстатокОтДеления) / 16;
		Результат        = Сред("0123456789abcdef", ОстатокОтДеления + 1, 1) + Результат;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПреобразоватьИзШестнадцатиричнойСистемыСчисленияВДесятичноеЧисло(Знач Значение)
	
	Значение = НРег(Значение);
	ДлинаСтроки = СтрДлина(Значение);
	
	Результат = 0;
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		Результат = Результат * 16 + СтрНайти("0123456789abcdef", Сред(Значение, НомерСимвола, 1)) - 1;
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧГ=0");
	
КонецФункции

Функция ЕстьКартинкаШтрихкодаВОбластиМакета(ОбластьМакета)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("КартинкаШтрихкода", Новый УникальныйИдентификатор);
	СтароеЗначение = СтруктураПоиска.КартинкаШтрихкода;
	
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, ОбластьМакета.Рисунки);
	
	Возврат Не СтруктураПоиска.КартинкаШтрихкода = СтароеЗначение;
	
КонецФункции

#КонецОбласти
