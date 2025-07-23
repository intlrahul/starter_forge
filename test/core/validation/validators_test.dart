import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/core/validation/validators.dart';

void main() {
  group('Validators', () {
    group('email', () {
      test('returns null for valid email', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('user.name+tag@domain.co.uk'), isNull);
        expect(Validators.email('valid123@test-domain.org'), isNull);
      });

      test('returns error for null or empty email', () {
        expect(Validators.email(null), equals('Email is required'));
        expect(Validators.email(''), equals('Email is required'));
        expect(Validators.email('   '), equals('Please enter a valid email address'));
      });

      test('returns error for invalid email format', () {
        expect(Validators.email('invalid'), equals('Please enter a valid email address'));
        expect(Validators.email('test@'), equals('Please enter a valid email address'));
        expect(Validators.email('@domain.com'), equals('Please enter a valid email address'));
        expect(Validators.email('test.domain.com'), equals('Please enter a valid email address'));
      });
    });

    group('password', () {
      test('returns null for valid password', () {
        expect(Validators.password('Password123'), isNull);
        expect(Validators.password('ComplexP@ss1'), isNull);
      });

      test('returns error for null or empty password', () {
        expect(Validators.password(null), equals('Password is required'));
        expect(Validators.password(''), equals('Password is required'));
      });

      test('returns error for password too short', () {
        expect(Validators.password('Pass1'), equals('Password must be at least 8 characters long'));
      });

      test('returns error for password missing requirements', () {
        expect(Validators.password('password123'), equals('Password must contain at least one uppercase letter'));
        expect(Validators.password('PASSWORD123'), equals('Password must contain at least one lowercase letter'));
        expect(Validators.password('PasswordABC'), equals('Password must contain at least one number'));
      });
    });

    group('required', () {
      test('returns null for valid input', () {
        expect(Validators.required('valid input'), isNull);
        expect(Validators.required('test'), isNull);
      });

      test('returns error for null or empty input', () {
        expect(Validators.required(null), equals('This field is required'));
        expect(Validators.required(''), equals('This field is required'));
        expect(Validators.required('   '), equals('This field is required'));
      });

      test('uses custom field name in error message', () {
        expect(Validators.required(null, fieldName: 'Name'), equals('Name is required'));
        expect(Validators.required('', fieldName: 'Email'), equals('Email is required'));
      });
    });

    group('phoneNumber', () {
      test('returns null for valid phone numbers', () {
        expect(Validators.phoneNumber('1234567890'), isNull);
        expect(Validators.phoneNumber('+1 (555) 123-4567'), isNull);
        expect(Validators.phoneNumber('+44 20 7946 0958'), isNull);
      });

      test('returns error for null or empty phone number', () {
        expect(Validators.phoneNumber(null), equals('Phone number is required'));
        expect(Validators.phoneNumber(''), equals('Phone number is required'));
      });

      test('returns error for invalid phone number', () {
        expect(Validators.phoneNumber('123'), equals('Please enter a valid phone number'));
        expect(Validators.phoneNumber('abc123def'), equals('Please enter a valid phone number'));
      });
    });

    group('name', () {
      test('returns null for valid names', () {
        expect(Validators.name('John Doe'), isNull);
        expect(Validators.name('Mary Jane Smith'), isNull);
        expect(Validators.name('Al'), isNull);
      });

      test('returns error for null or empty name', () {
        expect(Validators.name(null), equals('Name is required'));
        expect(Validators.name(''), equals('Name is required'));
        expect(Validators.name('   '), equals('Name is required'));
      });

      test('returns error for name too short', () {
        expect(Validators.name('J'), equals('Name must be at least 2 characters long'));
      });

      test('returns error for name with invalid characters', () {
        expect(Validators.name('John123'), equals('Name can only contain letters and spaces'));
        expect(Validators.name('John@Doe'), equals('Name can only contain letters and spaces'));
      });
    });

    group('url', () {
      test('returns null for valid URLs', () {
        expect(Validators.url('https://example.com'), isNull);
        expect(Validators.url('http://www.test.org/path'), isNull);
        expect(Validators.url('https://subdomain.domain.co.uk/path?query=1'), isNull);
      });

      test('returns error for null or empty URL', () {
        expect(Validators.url(null), equals('URL is required'));
        expect(Validators.url(''), equals('URL is required'));
      });

      test('returns error for invalid URL format', () {
        expect(Validators.url('invalid-url'), equals('Please enter a valid URL'));
        expect(Validators.url('ftp://example.com'), equals('Please enter a valid URL'));
      });
    });

    group('numeric', () {
      test('returns null for valid numbers', () {
        expect(Validators.numeric('123'), isNull);
        expect(Validators.numeric('45.67'), isNull);
        expect(Validators.numeric('-89.12'), isNull);
      });

      test('returns error for null or empty input', () {
        expect(Validators.numeric(null), equals('This field is required'));
        expect(Validators.numeric(''), equals('This field is required'));
      });

      test('returns error for non-numeric input', () {
        expect(Validators.numeric('abc'), equals('Please enter a valid number'));
        expect(Validators.numeric('12.34.56'), equals('Please enter a valid number'));
      });

      test('uses custom field name in error message', () {
        expect(Validators.numeric(null, fieldName: 'Age'), equals('Age is required'));
      });
    });

    group('minLength', () {
      test('returns null for valid input', () {
        expect(Validators.minLength('hello', 3), isNull);
        expect(Validators.minLength('test', 4), isNull);
      });

      test('returns error for null or empty input', () {
        expect(Validators.minLength(null, 3), equals('This field is required'));
        expect(Validators.minLength('', 3), equals('This field is required'));
      });

      test('returns error for input too short', () {
        expect(Validators.minLength('hi', 3), equals('This field must be at least 3 characters long'));
      });

      test('uses custom field name in error message', () {
        expect(Validators.minLength('hi', 3, fieldName: 'Password'), equals('Password must be at least 3 characters long'));
      });
    });

    group('maxLength', () {
      test('returns null for valid input', () {
        expect(Validators.maxLength('hello', 10), isNull);
        expect(Validators.maxLength('test', 4), isNull);
        expect(Validators.maxLength(null, 5), isNull);
      });

      test('returns error for input too long', () {
        expect(Validators.maxLength('hello world', 5), equals('This field cannot exceed 5 characters'));
      });

      test('uses custom field name in error message', () {
        expect(Validators.maxLength('too long', 5, fieldName: 'Bio'), equals('Bio cannot exceed 5 characters'));
      });
    });

    group('confirmPassword', () {
      test('returns null for matching passwords', () {
        expect(Validators.confirmPassword('password123', 'password123'), isNull);
      });

      test('returns error for null or empty confirm password', () {
        expect(Validators.confirmPassword(null, 'password'), equals('Please confirm your password'));
        expect(Validators.confirmPassword('', 'password'), equals('Please confirm your password'));
      });

      test('returns error for non-matching passwords', () {
        expect(Validators.confirmPassword('password1', 'password2'), equals('Passwords do not match'));
      });
    });

    group('age', () {
      test('returns null for valid age', () {
        expect(Validators.age('25'), isNull);
        expect(Validators.age('18', minAge: 18), isNull);
        expect(Validators.age('65', maxAge: 65), isNull);
      });

      test('returns error for null or empty age', () {
        expect(Validators.age(null), equals('Age is required'));
        expect(Validators.age(''), equals('Age is required'));
      });

      test('returns error for invalid age format', () {
        expect(Validators.age('abc'), equals('Please enter a valid age'));
        expect(Validators.age('25.5'), equals('Please enter a valid age'));
      });

      test('returns error for age out of range', () {
        expect(Validators.age('17', minAge: 18), equals('Age must be at least 18'));
        expect(Validators.age('130', maxAge: 120), equals('Age cannot exceed 120'));
      });
    });

    group('date', () {
      test('returns null for valid date', () {
        expect(Validators.date('2023-12-25'), isNull);
        expect(Validators.date('2023-01-01'), isNull);
      });

      test('returns error for null or empty date', () {
        expect(Validators.date(null), equals('Date is required'));
        expect(Validators.date(''), equals('Date is required'));
      });

      test('returns error for invalid date format', () {
        expect(Validators.date('invalid-date'), equals('Please enter a valid date (YYYY-MM-DD)'));
        expect(Validators.date('25/12/2023'), equals('Please enter a valid date (YYYY-MM-DD)'));
      });
    });

    group('combine', () {
      test('returns null when all validators pass', () {
        final validators = [
          (String? value) => Validators.required(value),
          (String? value) => Validators.minLength(value, 3),
        ];
        expect(Validators.combine('hello', validators), isNull);
      });

      test('returns first validation error', () {
        final validators = [
          (String? value) => Validators.required(value),
          (String? value) => Validators.minLength(value, 10),
        ];
        expect(Validators.combine('hi', validators), equals('This field must be at least 10 characters long'));
      });

      test('returns error from first failing validator', () {
        final validators = [
          (String? value) => Validators.required(value),
          (String? value) => Validators.email(value),
        ];
        expect(Validators.combine('', validators), equals('This field is required'));
      });
    });
  });
}
