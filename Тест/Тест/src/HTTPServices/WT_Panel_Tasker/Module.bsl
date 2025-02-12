#Область ОбработчикиСобытий
Функция СоздатьЗаявкуcreateapplication(Запрос)
	
	///+ГомзМА 03.05.2024
	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(Тело);
	
	Массив  = ПрочитатьJSON(ЧтениеJSON);
	
	НомерТелефона = Массив.number;
	НомерТелефона = ПолучитьНормализованныйНомер(НомерТелефона); 
	
	Попытка
		НоваяЗаявка = Документы.ЗаказКлиента.СоздатьДокумент(); 
		НоваяЗаявка.Дата = ТекущаяДатаСеанса();
		НоваяЗаявка.НомерТелефона = НомерТелефона;
		НоваяЗаявка.WTPanel = Справочники.СтатусыWT.НайтиПоКоду("000000017"); //Ожидание
		НоваяЗаявка.Состояние = Перечисления.дт_СостоянияЗаказовКлиента.Ожидание;
		НоваяЗаявка.ПодстатусОбработки = Перечисления.ПодстатусыОбработкиЗаявок.Ожидание;
		НоваяЗаявка.Клиент = ПолучитьКлиентаПоТелефону(НомерТелефона);
		НоваяЗаявка.Записать();
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
		Ответ.УстановитьТелоИзСтроки("Заявка № " + НоваяЗаявка.Номер + " успешно создана");
	Исключение
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
		Ответ.УстановитьТелоИзСтроки("Не удалось создать заявку");
	КонецПопытки; 

	Возврат Ответ;
	///-ГомзМА 03.05.2024
	
КонецФункции 


#КонецОбласти


#Область СлужебныеПроцедурыИФункции
Функция ПолучитьНормализованныйНомер(Номер)

	///+ГомзМА 03.05.2024
	ПромежуточныйНомер = "";
	ДопустимыеСимволы = "0123456789";
	ДлинаНомера = СтрДлина(СокрЛП(Номер));
	Для Сч1 = 1 По ДлинаНомера Цикл
		ТекСимвол = Сред(СокрЛП(Номер), Сч1, 1);
		Если СтрНайти(ДопустимыеСимволы, ТекСимвол) > 0 Тогда
			ПромежуточныйНомер = ПромежуточныйНомер + ТекСимвол;
			Если Лев(ПромежуточныйНомер, 1) = "8" Тогда
				ПромежуточныйНомер = "7";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если Лев(ПромежуточныйНомер, 1) = "7" Тогда
		ПромежуточныйНомер = "+" + ПромежуточныйНомер;
	КонецЕсли;
	
	ФорматированныйНомер = Лев(ПромежуточныйНомер, 2) + " " + Сред(ПромежуточныйНомер, 3, 3) + " " + Сред(ПромежуточныйНомер, 6, 3) + "-" + Сред(ПромежуточныйНомер, 9, 2) + "-" + Сред(ПромежуточныйНомер, 11);
	
	Возврат ФорматированныйНомер;
	///-ГомзМА 03.05.2024
		
КонецФункции

Функция ПолучитьКлиентаПоТелефону(Номер)

	///+ГомзМА 03.05.2024
	Результат = Справочники.Клиенты.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Клиенты.Ссылка
		|ИЗ
		|	Справочник.Клиенты КАК Клиенты
		|ГДЕ
		|	Клиенты.Телефон = &Телефон";
	
	Запрос.УстановитьПараметр("Телефон", Номер);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Количество() > 0 Тогда
		РезультатЗапроса.Следующий();
		Результат = РезультатЗапроса.Ссылка;
	КонецЕсли;
	Возврат Результат;
	///-ГомзМА 03.05.2024
		
КонецФункции
#КонецОбласти