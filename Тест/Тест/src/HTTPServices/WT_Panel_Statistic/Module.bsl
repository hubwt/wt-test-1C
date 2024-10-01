#Область ОбработчикиСобытий

Функция ПолучитьСтатистикуКадровgetstatisticpersonnel(Запрос)
	
	///+ТатарМА 30.09.2024
	ЗапросАналитикаКадров = Новый Запрос;
	
	ЗапросАналитикаКадров.Текст = "ВЫБРАТЬ
	|	АналитикаВакансий.Вакансия КАК Вакансия,
	|	АналитикаВакансий.ДатаСоздания КАК ДатаСоздания,
	|	АналитикаВакансий.Ответственный КАК Ответственный,
	|	АналитикаВакансий.ДатаЗакрытия КАК ДатаЗакрытия,
	|	АналитикаВакансий.КадровыйПриказ КАК КадровыйПриказ,
	|	АналитикаВакансий.Сотрудник КАК Сотрудник,
	|	АналитикаВакансий.ПериодПоиска КАК ПериодПоиска,
	|	АналитикаВакансий.Увольнение КАК Увольнения,
	|	АналитикаВакансий.ДатаУвольнения КАК ДатаУвольнения,
	|	АналитикаВакансий.ПериодРаботы КАК ПериодРаботы
	|ИЗ
	|	РегистрСведений.АналитикаВакансий КАК АналитикаВакансий";
	
	Выборка = ЗапросАналитикаКадров.Выполнить().Выбрать();

	МассивКадров = Новый Массив;
	Пока Выборка.Следующий() Цикл
		СтруктураИнфо = Новый Структура;
		СтруктураИнфо.Вставить("vacancy", 			Строка(выборка.Вакансия));
		СтруктураИнфо.Вставить("date_creation", 	Строка(выборка.ДатаСоздания));
		СтруктураИнфо.Вставить("responsible", 		Строка(выборка.Ответственный));
		СтруктураИнфо.Вставить("date_closing", 		Строка(выборка.ДатаЗакрытия));
		СтруктураИнфо.Вставить("personnel_order", 	Строка(Выборка.КадровыйПриказ));
		СтруктураИнфо.Вставить("employee", 			Строка(выборка.Сотрудник));
		СтруктураИнфо.Вставить("search_period", 	Строка(выборка.ПериодПоиска));
		СтруктураИнфо.Вставить("dismissal", 		Строка(выборка.Увольнения));
		СтруктураИнфо.Вставить("date_dismissal", 	Строка(выборка.ДатаУвольнения));
		СтруктураИнфо.Вставить("period_work", 		Строка(выборка.ПериодРаботы));

		МассивКадров.Добавить(СтруктураИнфо);
	КонецЦикла;

	СтруктураОтвета = Новый Структура;

	СтруктураОтвета.Вставить("info", МассивКадров);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);

	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;
	///-ТатарМА 30.09.2024
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти