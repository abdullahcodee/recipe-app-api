from django.test import SimpleTestCase
from app import calc

class CalcTest(SimpleTestCase):
    def test_add_numbers(self):
        result = calc.add_numbers(5,6)
        return self.assertEqual(result,11)
    
    def test_subtract_numbers(self):
        result = calc.subtract_numbers(15,10)
        return self.assertEqual(result,5)