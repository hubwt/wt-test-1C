#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс





#КонецОбласти

#Область ОбработчикиСобытий


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не ЗначениеЗаполнено(НомерИсходящий) Тогда
		НомерИсходящий = дт_Нумерация.СвободныйНомерДокумента(
				Метаданные().Имя, 
				Дата, 
				дт_ОбщегоНазначения.ПрефиксОрганизации(Организация),
				"НомерИсходящий",
				Ссылка
		);
	КонецЕсли;
	
	// Заполним показатели сотрудников из профиля
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		дт_ПоказателиСотрудников.ЗаполнитьПоказателиСотрудников(Сотрудники.Выгрузить(), Отказ);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	
	
	//ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	
КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ДолжностиСотрудников
	Движения.ДолжностиСотрудников.Записывать = Истина;
	Движение = Движения.ДолжностиСотрудников.Добавить();
	Движение.Период = Дата;
	Движение.Организация = Организация;
	Движение.Подразделение = Отдел;
	Движение.Сотрудник = Сотрудник;
	Движение.Должность = Должность;
	Движение.ТипДоговора = ТипДоговора;
	Движение.ДатаОформления = ДатаДоговора;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры


Процедура Староепроведение(Отказ, РежимПроведения)
	ДополнительныеСвойства.Вставить("ЭтоНовый",                    ЭтоНовый()); 
	ДополнительныеСвойства.Вставить("ДатаДокументаСдвинутаВперед", Ложь); 
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	
	ПараметрыПроведения = Документы.КадровыйПриказ.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
	// Формирование движений
	дт_Зарплата.ОтразитьДолжностиСотрудников(ПараметрыПроведения, Движения, Отказ);
	дт_Зарплата.ОтразитьНадбавкиПлан(ПараметрыПроведения, Движения, Отказ);

КонецПроцедуры





#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли





