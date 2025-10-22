import XCTest
@testable import MagnusDomain

final class NewsMaterialToNewsAttachmentConverterTests: XCTestCase {
    
    func test_convertMultipleNewsMaterials_shouldReturnCorrectNumberOfAttachments() {
        // Given
        let newsMaterials = [
            NewsMaterial(
                id: "1",
                title: "PDF Document",
                link: "https://example.com/document.pdf",
                file_type: .pdf
            ),
            NewsMaterial(
                id: "2",
                title: "Word Document",
                link: "https://example.com/document.docx",
                file_type: .docx
            ),
            NewsMaterial(
                id: "3",
                title: "External Link",
                link: "https://example.com/page",
                file_type: .link
            ),
            NewsMaterial(
                id: "4",
                title: "SharePoint File",
                link: "https://sharepoint.com/file",
                file_type: .sharepoint
            )
        ]
        
        // When
        let attachments = NewsMaterialToNewsAttachmentConverter.convert(newsMaterials: newsMaterials)
        
        // Then
        XCTAssertEqual(attachments.count, 4, "Should convert all 4 materials")
        
        // Verify first attachment
        XCTAssertEqual(attachments[0].title, "PDF Document")
        XCTAssertEqual(attachments[0].type, .pdf)
        XCTAssertEqual(attachments[0].content, "https://example.com/document.pdf")
        XCTAssertEqual(attachments[0].url, "https://example.com/document.pdf")
        
        // Verify second attachment
        XCTAssertEqual(attachments[1].title, "Word Document")
        XCTAssertEqual(attachments[1].type, .docx)
        XCTAssertEqual(attachments[1].content, "https://example.com/document.docx")
        XCTAssertEqual(attachments[1].url, "https://example.com/document.docx")
        
        // Verify third attachment
        XCTAssertEqual(attachments[2].title, "External Link")
        XCTAssertEqual(attachments[2].type, .link)
        XCTAssertEqual(attachments[2].content, "https://example.com/page")
        XCTAssertEqual(attachments[2].url, "https://example.com/page")
        
        // Verify fourth attachment
        XCTAssertEqual(attachments[3].title, "SharePoint File")
        XCTAssertEqual(attachments[3].type, .sharepoint)
        XCTAssertEqual(attachments[3].content, "https://sharepoint.com/file")
        XCTAssertEqual(attachments[3].url, "https://sharepoint.com/file")
    }
    
    func test_convertEmptyArray_shouldReturnEmptyArray() {
        // Given
        let newsMaterials: [NewsMaterial] = []
        
        // When
        let attachments = NewsMaterialToNewsAttachmentConverter.convert(newsMaterials: newsMaterials)
        
        // Then
        XCTAssertTrue(attachments.isEmpty, "Should return empty array for empty input")
    }
    
    func test_convertSingleNewsMaterial_shouldReturnSingleAttachment() {
        // Given
        let newsMaterial = NewsMaterial(
            id: "1",
            title: "Test Document",
            link: "https://example.com/test.pdf",
            file_type: .pdf
        )
        
        // When
        let attachment = NewsMaterialToNewsAttachmentConverter.convert(newsMaterial: newsMaterial)
        
        // Then
        XCTAssertEqual(attachment.title, "Test Document")
        XCTAssertEqual(attachment.type, .pdf)
        XCTAssertEqual(attachment.content, "https://example.com/test.pdf")
        XCTAssertEqual(attachment.url, "https://example.com/test.pdf")
    }
    
    func test_convertMultipleMaterials_shouldPreserveOrder() {
        // Given
        let newsMaterials = [
            NewsMaterial(id: "1", title: "First", link: "link1", file_type: .pdf),
            NewsMaterial(id: "2", title: "Second", link: "link2", file_type: .docx),
            NewsMaterial(id: "3", title: "Third", link: "link3", file_type: .link),
            NewsMaterial(id: "4", title: "Fourth", link: "link4", file_type: .sharepoint)
        ]
        
        // When
        let attachments = NewsMaterialToNewsAttachmentConverter.convert(newsMaterials: newsMaterials)
        
        // Then
        XCTAssertEqual(attachments[0].title, "First")
        XCTAssertEqual(attachments[1].title, "Second")
        XCTAssertEqual(attachments[2].title, "Third")
        XCTAssertEqual(attachments[3].title, "Fourth")
    }
}
