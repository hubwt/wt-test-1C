#Область ПрограммныйИнтерфейс

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция НаименованиеДоговора(Объект) Экспорт

	Возврат СтрШаблон("Договор №%1 от %2 г.", Объект.НомерДоговора, Формат(Объект.ДатаДоговора, "ДЛФ=D"));	

КонецФункции // НаименованиеДоговора()

Функция УчетПоСкладам(ДатаСостояния) Экспорт
	
	Возврат ДатаСостояния >= дт_ОбщегоНазначенияВызовСервераПовтИсп.ДатаНачалаВеденияСкладскогоУчета();
	
КонецФункции

Функция СтрокаИзМассиваСтрок(МассивСтрок, Разделитель, ИгнорироватьПустые = Истина) Экспорт
	
	Слова = Новый Массив();
	Для каждого Строка Из МассивСтрок Цикл
		
		Если Не ПустаяСтрока(Строка) Тогда
			Слова.Добавить(Строка);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат СтрСоединить(Слова, Разделитель);
		
КонецФункции

Функция ФорматВремени(ВремяВДесятичномФормате) Экспорт
	Ч = Цел(ВремяВДесятичномФормате);
	М = Окр((ВремяВДесятичномФормате - Ч) * 60, 0);
	
	Возврат СтрШаблон("%1:%2", 
		СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Формат(Ч, "ЧВН=;"), 2), 
		СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Формат(М, "ЧВН=;"), 2)
	);
КонецФункции

//	Время - тип Дата
Функция ВремяВЧасы(Время) Экспорт
	
	Возврат (Время - НачалоДня(Время)) / 3600;
	
КонецФункции

// ВремяСтр - Строка вида HH:mm[:ss]
Функция ВремяСтрВЧасы(ВремяСтр) Экспорт
	
	Результат = 0;
	Если ПустаяСтрока(ВремяСтр) Тогда
		Возврат Результат;
	КонецЕсли;
	
	СоставВремени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ВремяСтр, ":");
	Если СоставВремени.Количество() < 2
		ИЛИ СоставВремени.Количество() > 3 Тогда
		ВызватьИсключение "Неверный формат времени " + ВремяСтр;
	КонецЕсли;
	
	Попытка	
		Для Индекс = 0 По СоставВремени.Количество() - 1 Цикл
			СоставВремени[Индекс] = Число(СоставВремени[Индекс]);
		КонецЦикла;
	Исключение
		ВызватьИсключение "Неверный формат времени " + ВремяСтр;
	КонецПопытки;
	
	Если СоставВремени.Количество() = 2 Тогда
		СоставВремени.Добавить(0);
	КонецЕсли;

	Для Индекс = 0 По СоставВремени.Количество() - 1 Цикл
		Значение = СоставВремени[СоставВремени.Количество() - Индекс - 1];
		Результат = Результат + Значение * Pow(60, Индекс);
	КонецЦикла;
	
	Результат = Результат / 3600;
	
	Возврат Результат;
	
КонецФункции

Функция ЧасыВоВремя(Час) Экспорт
	Ч = Цел(Час);
	М = Окр((Час - Ч) * 60, 0);
	
	Возврат '00010101' + Ч * 3600 + М * 60;
КонецФункции

Функция РазностьМесяцев(ДатаОкончания, ДатаНачала)

	Результат = Месяц(ДатаОкончания) + Год(ДатаОкончания) * 12 - Месяц(ДатаНачала) - Год(ДатаНачала) * 12;
	
	Возврат Результат;
	
КонецФункции // РазностьМесяцев()

Функция РазностьДат(ДатаОкончания, ДатаНачала, Периодичность) Экспорт

	Результат = 0;
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Результат = Цел(РазностьМесяцев(ДатаОкончания, ДатаНачала) / 12);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		Результат = Цел(РазностьМесяцев(ДатаОкончания, ДатаНачала) / 6);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Результат = Цел(РазностьМесяцев(ДатаОкончания, ДатаНачала) / 3);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Результат = РазностьМесяцев(ДатаОкончания, ДатаНачала);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Результат = Цел((ДатаОкончания - ДатаНачала) / (60 * 60 * 24));
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции // РазностьДат()


Функция ДобавитьКДате(ДатаНачала, Количество, Периодичность)  Экспорт

	Результат = ДатаНачала;
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Результат = ДобавитьМесяц(ДатаНачала, 12);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		Результат = ДобавитьМесяц(ДатаНачала, 6);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Результат = ДобавитьМесяц(ДатаНачала, 3);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Результат = ДобавитьМесяц(ДатаНачала, 1);
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		Результат = ДатаНачала + 24 * 60 * 60;
		
	КонецЕсли;

	Возврат Результат;
	

КонецФункции // ДобавитьКДате()


// Распределяет сумму пропорционально заданной таблице и возвращает таблицу распределение
//
//	Параметры:
//		Сумма
//		ТаблицаБаза - ТаблицаЗначений, Массив строк таблицы
//		СоздатьНовуюТаблицу - Булево - Если Ложь, то расчеты ведутся непосредственно в ТаблицаБаза, иначе создается копия
//		ИмяРеквизитаСуммаБазы - Строка
//		ИмяРеквизитаСумма		- Строка
//		Разрядность				- Число - разрядность округления
//		НормализоватьПоБазе		- Булево - признак того, что сумма распределения не должна превышать сумму базы (актуально для распределения по остаткам)
//
// Возвращаемое значение:
//   ТаблицаЗначений   - в зависимости от параметра СоздатьНовуюТаблицу: либо копия ТаблицаБаза, либо новая таблица 
Функция РаспределитьПропорционально(Сумма, ТаблицаБаза, СоздатьНовуюТаблицу = Ложь, ИмяРеквизитаСуммаБазы = "Сумма", ИмяРеквизитаСумма = "Сумма", Разрядность = 2, НормализоватьПоБазе = Ложь) Экспорт
	
	Если СоздатьНовуюТаблицу Тогда
		ТаблицаРаспределение = ТаблицаБаза.Скопировать();
	Иначе
		ТаблицаРаспределение = ТаблицаБаза;
	КонецЕсли;
	
	
	Если ТипЗнч(ТаблицаБаза) = Тип("Массив") Тогда
		СуммаИтого = 0;
		Для каждого СтрокаТаблицы Из ТаблицаБаза Цикл
		
			СуммаИтого = СуммаИтого + СтрокаТаблицы[ИмяРеквизитаСуммаБазы];
		
		КонецЦикла;
	Иначе	
	
		СуммаИтого = ТаблицаБаза.Итог(ИмяРеквизитаСуммаБазы);
		
	КонецЕсли;
	
	Для Индекс = 0 По ТаблицаБаза.Количество() - 1 Цикл
	
		СтрокаБазы = ТаблицаБаза[Индекс];	
		СтрокаРаспределение = ТаблицаРаспределение[Индекс];
		
		СтрокаРаспределение[ИмяРеквизитаСумма] = ?(СуммаИтого = 0, 0, Окр(Сумма * СтрокаБазы[ИмяРеквизитаСуммаБазы] / СуммаИтого, Разрядность));
		
		Если НормализоватьПоБазе Тогда
			
			СтрокаРаспределение[ИмяРеквизитаСумма] = Мин(СтрокаРаспределение[ИмяРеквизитаСумма], СтрокаБазы[ИмяРеквизитаСуммаБазы]);
			
		КонецЕсли;
	
	КонецЦикла;
	
	// После распределения проверим погрешность вычислений и отнесем ее на строку с макс. суммой
	Если ТипЗнч(ТаблицаРаспределение) = Тип("Массив") Тогда
		СуммаИтого = 0;
		Для каждого СтрокаТаблицы Из ТаблицаРаспределение Цикл
			СуммаИтого = СуммаИтого + СтрокаТаблицы[ИмяРеквизитаСумма];
		КонецЦикла;
	Иначе	
	
		СуммаИтого = ТаблицаРаспределение.Итог(ИмяРеквизитаСумма);
		
	КонецЕсли;
	
	Разница = Сумма - СуммаИтого;
	
	
	РаспределитьПогрешностьОкругления(
		ТаблицаРаспределение, 
		Разница, 
		ИмяРеквизитаСумма, 
		5 / pow(10, Разрядность + 1),
		?(НормализоватьПоБазе, ИмяРеквизитаСуммаБазы, "")); 
	
	Возврат ТаблицаРаспределение;
	
КонецФункции


// Распределеяет копейки на строку табличной части с максимальной суммой
// Коллекция - ТабличнаяЧасть, ТаблицаФормы или Массив - коллекция строк табличной часьт
// Разница - Число - распределяемая сумма
// ИмяРеквизитаСумма	
// Погрешность	
// ИмяКолонкиНорм - Имя колонки (свойства) коллекции строк, по которой надо нормализовать результат. Если не задано, то нормализации не происходит
//
Процедура РаспределитьПогрешностьОкругления(КоллекцияСтрок, Разница, ИмяРеквизитаСумма = "Сумма", Погрешность = 0, ИмяКолонкиНорм = "") Экспорт

	
	// Добавить копейки (разница между суммой шапки и итогом по строкам)
	Если Разница = 0
		ИЛИ МодульЧисла(Разница) < Погрешность Тогда
		
		Возврат;		
		
	КонецЕсли;
	
	ИспользоватьНормализацию = ЗначениеЗаполнено(ИмяКолонкиНорм);
	
	Если ИспользоватьНормализацию Тогда
		// разницу "по крупицам" будем распределять по строкам, не превышая норму
		ОсталосьРаспределить = Разница;
		Индекс = 0;
		Пока ОсталосьРаспределить <> 0 Цикл
 			СтрокаТаблицы = КоллекцияСтрок[Индекс];
			
			Если СтрокаТаблицы[ИмяРеквизитаСумма] = СтрокаТаблицы[ИмяКолонкиНорм] Тогда
				Продолжить
			КонецЕсли;	
				
			Распределить = Мин(ОсталосьРаспределить, СтрокаТаблицы[ИмяКолонкиНорм] - СтрокаТаблицы[ИмяРеквизитаСумма]);
			СтрокаТаблицы[ИмяРеквизитаСумма] = СтрокаТаблицы[ИмяРеквизитаСумма] + Распределить;
			
			ОсталосьРаспределить = ОсталосьРаспределить - Распределить;	
				
				
			Индекс = Индекс + 1;
			
			Если Индекс >= КоллекцияСтрок.Количество() Тогда
				Прервать
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		// Найдем строку с макс. суммой
		СтрокаСМаксСуммой = Неопределено;
		Для каждого СтрокаТабличнойЧасти Из КоллекцияСтрок Цикл
			
			Если СтрокаСМаксСуммой = Неопределено Тогда
				
				СтрокаСМаксСуммой = СтрокаТабличнойЧасти;
				Продолжить;
				
			КонецЕсли;
			
			
			Если СтрокаТабличнойЧасти[ИмяРеквизитаСумма] > СтрокаСМаксСуммой[ИмяРеквизитаСумма] Тогда
				
				СтрокаСМаксСуммой = СтрокаТабличнойЧасти;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если СтрокаСМаксСуммой = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		СтрокаСМаксСуммой[ИмяРеквизитаСумма] = СтрокаСМаксСуммой[ИмяРеквизитаСумма] + Разница;
		
	КонецЕсли;
	

КонецПроцедуры // РаспределитьПогрешностьОкругления()

// Возвращает модуль числа
//
// Возвращаемое значение:
//   Число   - модуль числа
//
Функция МодульЧисла(Число1) Экспорт
	
	Возврат ?(Число1 < 0, -Число1, Число1);

КонецФункции // МодульЧисла()

Функция СравнитьСтруктуры(Стр1, Стр2) Экспорт
	
	Результат = Истина;
	
	Для каждого Поле Из Стр1 Цикл
	
		Результат = Стр1[Поле.Ключ] = Стр2[Поле.Ключ];
		Если НЕ Результат Тогда
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Результат;
КонецФункции


Функция ГУИД_в_строку(ГУИД) Экспорт
	Возврат "_" + СтрЗаменить(Строка(ГУИД), "-", "_");
КонецФункции

Функция Строка_в_ГУИД(Идентификатор) Экспорт
	Результат = СтрЗаменить(Сред(Идентификатор, 2), "_", "-");
	
	Возврат Новый УникальныйИдентификатор(Результат);
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти