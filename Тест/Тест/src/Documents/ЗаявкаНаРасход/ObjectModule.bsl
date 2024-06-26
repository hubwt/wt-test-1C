
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АктВозврата") Тогда
		// Заполнение шапки
		Статус 		   = Перечисления.дт_СтатусыЗаявокНаРасход.Внепланово;
		Инициатор 	   = Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь",ДанныеЗаполнения.Ответственный);
		Основание 	   = ДанныеЗаполнения.Ссылка;
		ВидРасхода	   = Справочники.ВидыРасходов.НайтиПоКоду("000000041");
		Получатель 	   = ДанныеЗаполнения.Ответственный;
		Ответственный  = ДанныеЗаполнения.Ответственный;
		СуммаДокумента = ДанныеЗаполнения.ОбщаяСумма;
		
		Для Каждого ТекСтрокаТаблица Из ДанныеЗаполнения.Таблица Цикл
			НоваяСтрока = Запчасти.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрокаТаблица.Товар;
			НоваяСтрока.Код = ТекСтрокаТаблица.Товар.Код;
			НоваяСтрока.НомерПроизводителя = ТекСтрокаТаблица.Товар.НомерПроизводителя;
			НоваяСтрока.Количество 	 = ТекСтрокаТаблица.Количество;
			НоваяСтрока.Сумма 		 = ТекСтрокаТаблица.Сумма;
			НоваяСтрока.Цена 		 = ТекСтрокаТаблица.Цена;
		КонецЦикла;
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеЗапчастей") Тогда
		
			
				
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПоступлениеЗапчастей.Поставшик КАК Поставшик,
			|	ПоступлениеЗапчастей.Организация КАК Организация,
			|	ВЫБОР
			|		КОГДА ПоступлениеЗапчастей.Проведен
			|			ТОГДА ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0)
			|		ИНАЧЕ ПоступлениеЗапчастей.СуммаНакладной
			|	КОНЕЦ КАК СуммаДокумента,
			|	ПоступлениеЗапчастей.Проект КАК Проект
			|ИЗ
			|	Документ.ПоступлениеЗапчастей КАК ПоступлениеЗапчастей
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСПоставщиками.Остатки(, Сделка = &Ссылка) КАК РасчетыСПоставщикамиОстатки
			|		ПО (РасчетыСПоставщикамиОстатки.Сделка = ПоступлениеЗапчастей.Ссылка)
			|ГДЕ
			|	ПоступлениеЗапчастей.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаШапка = РезультатЗапроса.Выбрать();
		ВыборкаШапка.Следующий(); 
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
		
		Основание = ДанныеЗаполнения;
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику");
		
		ВидРасхода = дт_ОбщегоНазначенияВызовСервераПовтИсп.ПолучитьОсновнойВидРасхода(ВидОперации);
		Для Каждого ТекСтрокаТаблица Из ДанныеЗаполнения.Таблица Цикл
			НоваяСтрока = Запчасти.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрокаТаблица.Товар;
			НоваяСтрока.Код = ТекСтрокаТаблица.Товар.Код;
			НоваяСтрока.НомерПроизводителя = ТекСтрокаТаблица.Товар.НомерПроизводителя;
			НоваяСтрока.Количество 	 = ТекСтрокаТаблица.Колво;
			НоваяСтрока.Сумма 		 = ТекСтрокаТаблица.СуммаПоступления;
			НоваяСтрока.Цена 		 = ТекСтрокаТаблица.Цена;
		КонецЦикла;
		
	    Инициатор = ОтборИнициатора(ДанныеЗаполнения); 
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Инициатор);

		Счет = ОтборСчета(ДанныеЗаполнения); 
		
		Получатель = ДанныеЗаполнения.Поставшик; 
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.дт_СтатусыЗаявокНаРасход.Планово;
	КонецЕсли; 
	// ++МазинЕС 24-05-24
			
			Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Расходы") Тогда
				// Заполняем шапку
				Инициатор 	   = ДанныеЗаполнения.Инициатор; 
				Основание 	   = ДанныеЗаполнения.Основание;
				ВидРасхода	   = ДанныеЗаполнения.ВидРасхода;
				Подразделение  = ДанныеЗаполнения.Подразделение; 
			
				
				Запрос = Новый Запрос;
				Запрос.Текст =
					"ВЫБРАТЬ
					|	ПоступлениеЗапчастейТаблица.Код КАК Код,
					|	ПоступлениеЗапчастейТаблица.Товар.НомерПроизводителя КАК НомерПроизводителя,
					|	ПоступлениеЗапчастейТаблица.Товар КАК Номенклатура,
					|	ПоступлениеЗапчастейТаблица.Колво КАК Колво,
					|	ПоступлениеЗапчастейТаблица.СуммаПоступления КАК СуммаПоступления,
					|	ПоступлениеЗапчастейТаблица.ЦенаПоступления КАК ЦенаПоступления
					|ИЗ
					|	Документ.ПоступлениеЗапчастей.Таблица КАК ПоступлениеЗапчастейТаблица
					|ГДЕ
					|	ПоступлениеЗапчастейТаблица.Ссылка = &Ссылка";
				
				Запрос.УстановитьПараметр("Ссылка",Основание );
				
				РезультатЗапроса = Запрос.Выполнить();
				Структура = Новый Структура; 
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
						НоваяСтрока = Товары.Добавить();
						НоваяСтрока.Код 				= ВыборкаДетальныеЗаписи.Код;
						НоваяСтрока.НомерПроизводителя  = ВыборкаДетальныеЗаписи.НомерПроизводителя;
						НоваяСтрока.Номенклатура 		= ВыборкаДетальныеЗаписи.Номенклатура; 
						НоваяСтрока.Количество 			= ВыборкаДетальныеЗаписи.Колво; 
						НоваяСтрока.Цена 				= ВыборкаДетальныеЗаписи.ЦенаПоступления;
						НоваяСтрока.Сумма 				= ВыборкаДетальныеЗаписи.СуммаПоступления;	 
				
				КонецЦикла;
		

			Конецесли; 
	// --МазинЕС 24-05-24
	
	
КонецПроцедуры

//Волков И.О. 29.11.2023 ++ 
Функция ОтборИнициатора(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сотрудники.Ссылка КАК Ответственный
	|ИЗ
	|	Документ.ПоступлениеЗапчастей КАК ПоступлениеЗапчастей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ПоступлениеЗапчастей.Ответственный = Сотрудники.Пользователь
	|ГДЕ
	|	ПоступлениеЗапчастей.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Пока ВыборкаШапка.Следующий() Цикл
		
		Инициатор = ВыборкаШапка.Ответственный;
		
	КонецЦикла;
	
	Возврат Инициатор;
КонецФункции  

Функция ОтборСчета(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Счета.Ссылка КАК СчетСсылка
	|ИЗ
	|	Документ.ПоступлениеЗапчастей КАК ПоступлениеЗапчастей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Счета КАК Счета
	|		ПО ПоступлениеЗапчастей.Организация = Счета.Владелец
	|ГДЕ
	|	ПоступлениеЗапчастей.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();	
	Пока ВыборкаШапка.Следующий() Цикл
		
		Счет = ВыборкаШапка.СчетСсылка;
		
	КонецЦикла;
	
	Возврат Счет;
	
КонецФункции
//Волков И.О. 29.11.2023 --

Процедура ПриКопировании(ОбъектКопирования)
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ДополнительныеСвойства.Вставить("ЭтоНовый",                    ЭтоНовый()); 
	ДополнительныеСвойства.Вставить("ДатаДокументаСдвинутаВперед", Ложь); 
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
//	
//	ПараметрыПроведения = Документы.ЗаказКлиента.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
//	Если Отказ Тогда
//		Возврат;
//	КонецЕсли;
	
	
	// Формирование движений
//	дт_Ценообразование.ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ);
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
		
// ++ МазинЕС 19-06-2024 // Реквизит ПлнируемыйРасход используется 
// в Динамическом списке ПлатежныйКалендарь
Если ДатаОплаты > Дата Тогда 
ПлнируемыйРасход = Истина; 
Иначе ПлнируемыйРасход = Ложь; 
КонецЕсли; 
// ++ МазинЕС 19-06-2024 	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли