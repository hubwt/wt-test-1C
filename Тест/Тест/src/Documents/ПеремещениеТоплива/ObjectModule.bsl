
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПеремещенияТоплива.БакБак") Тогда
		Склад = Неопределено;
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПеремещенияТоплива.БакСклад") Тогда
		БакПолучатель = Неопределено;
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПеремещенияТоплива.СкладБак") Тогда
		БакОтправитель = Неопределено;
	КонецЕсли;
	
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПеремещенияТоплива.БакБак") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		МассивНепроверяемыхРеквизитов.Добавить("Номенклатура");
		
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПеремещенияТоплива.БакСклад") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БакПолучатель");
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПеремещенияТоплива.СкладБак") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БакОтправитель");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	ВидОперации = Перечисления.ВидыОперацийПеремещенияТоплива.БакБак;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект);
	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ДополнительныеСвойства.Вставить("ЭтоНовый",                    ЭтоНовый()); 
	ДополнительныеСвойства.Вставить("ДатаДокументаСдвинутаВперед", Ложь); 
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	
	ПараметрыПроведения = Документы.ПеремещениеТоплива.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	дт_ОбщегоНазначения.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	дт_Склад.ПодготовитьНаборыЗаписей(ЭтотОбъект);
	дт_Грузоперевозки.ПодготовитьНаборыЗаписей(ЭтотОбъект);	
	
	// Формирование движений
	дт_Склад.ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ);
	дт_Грузоперевозки.ОтразитьТопливоВБаках(ПараметрыПроведения, Движения, Отказ);
	
	Движения.Записать();
	
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеТовары", ПараметрыПроведения.ТаблицаСписанныеТовары);
	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТопливоВБаках", ПараметрыПроведения.ТаблицаТопливоВБаках);
	ДополнительныеСвойства.ДляПроведения.МоментКонтроля = Новый Граница(МоментВремени(), ВидГраницы.Включая);
	
	// Контроль отрицательных остаткок по регистрам накопления
	Документы.ПеремещениеТоплива.ВыполнитьКонтрольТопливоВБаках(ЭтотОбъект, ДополнительныеСвойства, Отказ);
	Документы.ПеремещениеТоплива.ВыполнитьКонтрольТоварыНаСкладах(ЭтотОбъект, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти

#КонецЕсли