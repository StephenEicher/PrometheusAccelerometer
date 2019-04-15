# To Do:

- Record data only when flight is detected to save space
    - this can be accomplished by setting a G threshold
- Make sure the text file format is readable and efficient
    - consider using csv file with comma delimiters?
- Make sure that the text file won't be corrupted or overwritten if power is lost or otherwise
    - there's a feature called flush that could help with this but it will requre more power draw
- Reduce noise without reducing the data rate below 3000
- Arming procedures
- Refactor the code for organization
    - in progress
 - Note: The Adalogger also has an onboard RTC (Real Time Clock) chip that might be more reliable than micros but may also slow things down
