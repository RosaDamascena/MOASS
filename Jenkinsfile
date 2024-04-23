pipeline {
    agent any
    
    stages {
        stage('Spring Build') {
            steps {
                // Spring Boot 백엔드 빌드
                sh 'cd Backend/moass-api-server'
                sh 'ls'
                sh './gradlew build'
            }
        }
    }
    
    post {
        success {
            // 성공적으로 빌드 및 테스트 완료 시 수행할 작업
            echo 'Build and tests passed successfully!'
        }
        failure {
            // 빌드 또는 테스트 실패 시 수행할 작업
            echo 'Build or tests failed!'
        }
    }
}
