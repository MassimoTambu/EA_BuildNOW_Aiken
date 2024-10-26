pub type Action {
  Create
  Cancel
  Claim
}

pub type Person {
  name: ByteArray,
  age: Int,
  is_student: Bool,
}

pub type Person3 =
  Person

pub type PosixTime =
  Int

pub type Person2 {
  PersonalInfo { name: String, age: Int, is_student: Bool }
  Address { street: ByteArray, city: ByteArray, state: String, zip: Int }
}

pub type TheDatum {
  datum: Option<Int>,
}

pub fn check_datum_g10(dat: TheDatum) -> Bool {
  when dat.datum is {
    None -> False
    Some(x) -> x > 10
  }
}

pub fn show_name(person: Person) -> ByteArray {
  person.name
}

pub fn the_whole_variable(person: Person) -> Person {
  Person(person.name, person.age + 1, person.is_student)
}

test show_name_set07() {
  show_name(Person("Alice", 25, True)) == "Alice"
}

test show_new_person() {
  the_whole_variable(Person("Alice", 25, True)) == Person("Alice", 26, True)
}
