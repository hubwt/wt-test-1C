
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	/// Комлев АА 29/10/24 +++
	Форма = ОткрытьФорму("ОбщаяФорма.РейтингМенеджеров");
	Форма.Элементы.КоличествоКлиентовПоГруппам.Видимость = Истина;
	Форма.Элементы.Подстраницы.Видимость = Ложь;;
	Форма.ДатаДиаграммыКлиенты = ТекущаяДата();
	Форма.ОбновитьДиаграммуКлиенты();
	Форма.ОбновитьГрафикПриростАктивныхКлиентов();
	Форма.Заголовок = "Аналитика по клиентам";
	/// Комлев АА 29/10/24 ---
КонецПроцедуры