


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	//Настройки.СоответствиеПериодичностиПараметров.Вставить(Новый ПараметрКомпоновкиДанных("Период"), Перечисления.ДоступныеПериодыОтчета.Месяц);
	Настройки.ФормироватьСразу = Истина;
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	//Пользователь = Пользователи.ТекущийПользователь();
	
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ЕстьОтборПодразделение", НЕ Пользователи.ЭтоПолноправныйПользователь());
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Подразделение", дт_ПраваДоступа.ТекущееПодразделение());
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
КонецПроцедуры

#КонецОбласти

